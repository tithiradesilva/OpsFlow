package com.opsflow.opsflow.incident;

import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class IncidentService {

    private final IncidentRepository repository;

    public IncidentService(IncidentRepository repository) {
        this.repository = repository;
    }

    public List<Incident> getAll() {
        return repository.findAll();
    }

    public Incident getById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                   HttpStatus.NOT_FOUND,
                   "Incident not found"
                ));
    }

    public Incident create(Incident incident) {
        return repository.save(incident);
    }

    public Incident update(Long id, Incident updatedIncident) {
        Incident incident = getById(id);

        incident.setTitle(updatedIncident.getTitle());
        incident.setDescription(updatedIncident.getDescription());
        incident.setSeverity(updatedIncident.getSeverity());
        incident.setStatus(updatedIncident.getStatus());

        return repository.save(incident);
    }

    public void delete(Long id) {
        Incident incident = getById(id);
        repository.delete(incident);
    }
}
