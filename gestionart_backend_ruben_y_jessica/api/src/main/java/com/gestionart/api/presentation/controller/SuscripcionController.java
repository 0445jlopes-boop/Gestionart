package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.SuscripcionService;

@RestController
@RequestMapping("/suscripciones")
public class SuscripcionController {

    private final SuscripcionService suscripcionService;

    public SuscripcionController(SuscripcionService suscripcionService) {
        this.suscripcionService = suscripcionService;
    }

    @PutMapping("/{id}/activar")
    public ResponseEntity<Void> activar(@PathVariable Long id) {
        suscripcionService.activarPremium(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}/renovar")
    public ResponseEntity<Void> renovar(@PathVariable Long id) {
        suscripcionService.renovarPremium(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}/verificar")
    public ResponseEntity<Void> verificar(@PathVariable Long id) {
        suscripcionService.verificarExpiracion(id);
        return ResponseEntity.ok().build();
    }
}
