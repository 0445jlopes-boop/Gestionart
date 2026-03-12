package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.SolicitudExclusivaService;
import com.gestionart.api.common.mapper.SolicitudExclusivaMapper;
import com.gestionart.api.domain.models.SolicitudExclusiva;
import com.gestionart.api.presentation.dto.request.SolicitudExclusivaRequest;
import com.gestionart.api.presentation.dto.response.SolicitudExclusivaResponse;

@RestController
@RequestMapping("/solicitudes-exclusivas")
public class SolicitudExclusivaController {

    private final SolicitudExclusivaService solicitudService;
    private final SolicitudExclusivaMapper mapper;

    public SolicitudExclusivaController(SolicitudExclusivaService solicitudService,
                                        SolicitudExclusivaMapper mapper) {
        this.solicitudService = solicitudService;
        this.mapper = mapper;
    }

    @PostMapping
    public ResponseEntity<SolicitudExclusivaResponse> crear(
            @RequestBody SolicitudExclusivaRequest request) {

        SolicitudExclusiva solicitud = new SolicitudExclusiva(
                null,
                request.idComprador(),
                request.idArticulo(),
                request.idVendedor(),
                request.mensaje(),
                null,
                null
        );

        return ResponseEntity.ok(
                mapper.toResponse(
                        solicitudService.crear(solicitud)));
    }
}