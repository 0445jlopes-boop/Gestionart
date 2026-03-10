package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.SolicitudExclusivaService;
import com.gestionart.api.domain.models.SolicitudExclusiva;

@RestController
@RequestMapping("/solicitudes-exclusivas")
public class SolicitudExclusivaController {

    private final SolicitudExclusivaService solicitudService;

    public SolicitudExclusivaController(SolicitudExclusivaService solicitudService) {
        this.solicitudService = solicitudService;
    }

    @PostMapping
    public ResponseEntity<SolicitudExclusiva> crear(
            @RequestBody SolicitudExclusiva solicitud) {

        return ResponseEntity.ok(solicitudService.crear(solicitud));
    }
}