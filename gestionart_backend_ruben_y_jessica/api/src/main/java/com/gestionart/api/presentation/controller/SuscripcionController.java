package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.SuscripcionService;
import com.gestionart.api.common.mapper.SuscripcionMapper;
import com.gestionart.api.presentation.dto.request.SuscripcionRequest;
import com.gestionart.api.presentation.dto.response.SuscripcionResponse;

@RestController
@RequestMapping("/suscripciones")
public class SuscripcionController {

    private final SuscripcionService suscripcionService;
    private final SuscripcionMapper suscripcionMapper;

    public SuscripcionController(SuscripcionService suscripcionService,
                                 SuscripcionMapper suscripcionMapper) {
        this.suscripcionService = suscripcionService;
        this.suscripcionMapper = suscripcionMapper;
    }

    @PostMapping
    public ResponseEntity<SuscripcionResponse> activar(@RequestBody SuscripcionRequest request) {

        return ResponseEntity.ok(
                suscripcionMapper.toResponse(
                        suscripcionService.activarSuscripcion(
                                request.idComprador())));
    }
}
