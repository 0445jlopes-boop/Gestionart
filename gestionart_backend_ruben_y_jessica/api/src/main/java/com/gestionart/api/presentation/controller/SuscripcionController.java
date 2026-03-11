package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.SuscripcionService;
import com.gestionart.api.domain.models.Suscripcion;
import com.gestionart.api.presentation.dto.request.CrearSuscripcionRequest;

@RestController
@RequestMapping("/suscripciones")
public class SuscripcionController {

    private final SuscripcionService suscripcionService;

    public SuscripcionController(SuscripcionService suscripcionService) {
        this.suscripcionService = suscripcionService;
    }

    @PostMapping
    public ResponseEntity<Suscripcion> crear(@RequestBody CrearSuscripcionRequest request) {

        Suscripcion suscripcion = suscripcionService.activarSuscripcion(request.getIdComprador());

        return ResponseEntity.ok(suscripcion);
    }

}
