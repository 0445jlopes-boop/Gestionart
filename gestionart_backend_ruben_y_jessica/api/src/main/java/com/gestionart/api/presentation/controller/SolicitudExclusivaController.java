package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.SolicitudExclusivaService;
import com.gestionart.api.domain.models.SolicitudExclusiva;
import com.gestionart.api.presentation.dto.request.SolicitudExclusivaRequest;
import com.gestionart.api.presentation.dto.response.SolicitudExclusivaResponse;
import com.gestionart.api.presentation.mapper.SolicitudExclusivaMapper;

@RestController
@RequestMapping("/solicitudes-exclusivas")
public class SolicitudExclusivaController {

    private final SolicitudExclusivaService solicitudService;

    public SolicitudExclusivaController(SolicitudExclusivaService solicitudService) {
        this.solicitudService = solicitudService;
    }

    @PostMapping
    public ResponseEntity<SolicitudExclusivaResponse> crear(
            @RequestBody SolicitudExclusivaRequest request) {

        SolicitudExclusiva solicitud = new SolicitudExclusiva();
        solicitud.setIdComprador(request.getIdComprador());
        solicitud.setIdArticulo(request.getIdArticulo());
        solicitud.setIdVendedor(request.getIdVendedor());
        solicitud.setMensaje(request.getMensaje());

        return ResponseEntity.ok(
                SolicitudExclusivaMapper.toResponse(
                        solicitudService.crear(solicitud)));
    }
}