# OpsFlow — Production TechOps & Monitoring Platform

OpsFlow is a production-style incident management API built to demonstrate practical **TechOps, Platform Engineering, DevOps, SRE, and cloud operations** skills — deployment, monitoring, release management, and incident troubleshooting on AWS.

The CRUD functionality is intentionally simple. The focus is on how the application is **deployed, observed, maintained, and recovered** in a production-style environment.

**Repository:** https://github.com/tithiradesilva/OpsFlow

---

## Architecture

```text
                         Internet
                            │
                            ▼
                    ┌───────────────┐
                    │   AWS EC2     │
                    │    Ubuntu     │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │     Nginx     │
                    │     :80       │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │ Spring Boot   │
                    │     API       │
                    │    :8081      │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  PostgreSQL   │
                    │     :5432     │
                    └───────────────┘

              Monitoring / Observability

                    Spring Boot
                         │
                  Actuator / Micrometer
                         │
                         ▼
                    Prometheus :9090
                         │
                         ▼
                     Grafana :3000
```

Only Nginx is exposed publicly. The application, database, and monitoring stack communicate through the internal Docker network.

---

## Technology Stack

| Layer | Tools |
|---|---|
| **Application** | Java 21, Spring Boot, Spring Web, Spring Data JPA, Maven |
| **Database** | PostgreSQL |
| **Infrastructure** | AWS EC2, Ubuntu Server, Docker, Docker Compose, Nginx |
| **Monitoring** | Spring Boot Actuator, Micrometer, Prometheus, Grafana |
| **CI/CD** | GitHub Actions, Docker image builds, automated EC2 deployment |
| **Operational Tooling** | Bash, SSH, cURL, Git, PostgreSQL CLI, Docker CLI |

---

## API

OpsFlow manages operational incidents.

Each incident includes:

- Title
- Description
- Severity
- Status
- Creation timestamp

```text
GET    /api/incidents
GET    /api/incidents/{id}
POST   /api/incidents
PUT    /api/incidents/{id}
DELETE /api/incidents/{id}
```

Requests for a non-existent incident correctly return `404 Not Found`.

---

## Observability

### Health Checks

Spring Boot Actuator exposes:

```text
GET /actuator/health
```

The production application was verified through the public Nginx endpoint and returned:

```json
{
  "status": "UP"
}
```

### Metrics

Application metrics are exposed through:

```text
/actuator/prometheus
```

Prometheus scrapes the application and collects metrics including:

- Application availability
- JVM memory usage
- CPU usage
- HTTP request counts
- HTTP response metrics

Grafana provides the visualization layer.

### Alerting

`OpsFlowApplicationDown` fires when:

```text
up{job="opsflow-app"} == 0
```

for more than one minute.

The alert was verified by temporarily stopping the application, confirming that Prometheus detected the failure, and restarting the application to confirm recovery.

---

## CI/CD

### Continuous Integration

On pushes to the repository, GitHub Actions:

```text
Checkout
   ↓
Set up Java 21
   ↓
Maven build / verification
   ↓
Build Docker image
```

### Continuous Deployment

Deployment is triggered through GitHub Actions:

```text
GitHub Actions
      ↓
SSH to AWS EC2
      ↓
Pull latest code
      ↓
Build application
      ↓
Build containers
      ↓
Start services
      ↓
Health check
```

A deployment is only considered successful after the application health endpoint responds successfully.

### Deployment Version Tracking

Each deployment captures the Git commit being deployed using:

```bash
git rev-parse --short HEAD
```

The version is passed into the application and exposed through Spring Boot Actuator information, allowing the operator to identify **which version is currently running in production**.

---

## Release Management

The repository uses two primary branches:

```text
main
  └── Stable production branch

development
  └── Active development branch
```

Changes are developed on `development` and promoted to `main` when ready.

### Rollback

The project includes a rollback procedure that:

```text
Validate target commit
        ↓
Check working tree
        ↓
Checkout target version
        ↓
Rebuild application
        ↓
Rebuild containers
        ↓
Health check
        ↓
Confirm recovery
```

---

## Database Operations

PostgreSQL runs as a Docker service with dedicated backup and restore scripts.

### Backup

```bash
scripts/backup-db.sh
```

Creates a PostgreSQL dump in local server storage.

Backup files are excluded from Git.

### Restore

```bash
scripts/restore-db.sh <backup-file.sql>
```

Restoration was validated against a temporary database to confirm that the backup could be successfully restored without modifying the production database.

---

## Operational Scripts

```text
scripts/
├── health-check.sh
├── logs.sh
├── restart.sh
├── backup-db.sh
├── restore-db.sh
└── rollback.sh
```

These scripts provide repeatable procedures for common operational tasks including health checks, log inspection, application restart, database backup/restore, and rollback.

---

## Failure & Recovery Testing

An application outage was simulated to validate the detection-to-recovery path:

```text
Application stopped
        ↓
Nginx upstream fails
        ↓
Public endpoint becomes unavailable
        ↓
Prometheus detects failure
        ↓
Alert fires
        ↓
Application restarted
        ↓
Health restored
```

This demonstrated the relationship between application availability, reverse-proxy behaviour, monitoring, alerting, and recovery.

---

## Security

| Publicly Exposed | Internal Only |
|---|---|
| Nginx `:80` | PostgreSQL `:5432` |
| | Spring Boot `:8081` |
| | Prometheus `:9090` |
| | Grafana `:3000` |

Environment-specific configuration is stored in `.env`.

Secrets and environment files are excluded from Git.

---

## Project Outcomes

The project provided hands-on experience across the operational lifecycle of a production-style application:

```text
Develop
   ↓
Build
   ↓
Deploy
   ↓
Monitor
   ↓
Detect
   ↓
Troubleshoot
   ↓
Recover
   ↓
Backup
   ↓
Rollback
   ↓
Document
```

The main objective was to move beyond simply building an application and gain practical experience with how an application is **deployed, monitored, maintained, and recovered in a cloud environment**.

---

## Next Steps

The project will serve as the practical foundation for deeper learning in:

- Linux administration
- Incident response
- Production troubleshooting
- SRE practices
- Infrastructure automation
- Cloud operations
- Observability
- Release management

---

## Author

**Tithira Desilva**

BEng (Hons) Software Engineering, First Class — University of Westminster

**Interested in:** Platform Engineering • DevOps • SRE • Cloud Infrastructure • AI Infrastructure