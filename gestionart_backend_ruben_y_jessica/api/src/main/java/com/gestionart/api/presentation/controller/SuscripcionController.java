package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.SuscripcionService;
import com.gestionart.api.domain.models.Suscripcion;
import com.gestionart.api.presentation.dto.request.SuscripcionRequest;
import com.gestionart.api.presentation.dto.response.SuscripcionResponse;
import com.gestionart.api.presentation.mapper.SuscripcionMapper;

@RestController
@RequestMapping("/suscripciones")
public class SuscripcionController {

    private final SuscripcionService suscripcionService;

    public SuscripcionController(SuscripcionService suscripcionService) {
        this.suscripcionService = suscripcionService;
    }

    @PostMapping
    public ResponseEntity<SuscripcionResponse> activar(@RequestBody SuscripcionRequest request) {

        Suscripcion suscripcion =
                suscripcionService.activarSuscripcion(request.getIdComprador());

        return ResponseEntity.ok(SuscripcionMapper.toResponse(suscripcion));
    }
}
