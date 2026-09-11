package com.opsflow.opsflow.incident;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/incidents")
public class IncidentController {

    private final IncidentService service;

    public IncidentController(IncidentService service) {
        this.service = service;
    }

    @GetMapping
    public List<Incident> getAll() {
        return service.getAll();
    }

    @GetMapping("/{id}")
    public Incident getById(@PathVariable Long id) {
        return service.getById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Incident create(@RequestBody Incident incident) {
        return service.create(incident);
    }

    @PutMapping("/{id}")
    public Incident update(
            @PathVariable Long id,
            @RequestBody Incident incident) {
        return service.update(id, incident);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        service.delete(id);
    }
}