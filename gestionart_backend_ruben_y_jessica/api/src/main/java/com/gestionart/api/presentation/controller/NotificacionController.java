package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.NotificacionService;
import com.gestionart.api.domain.models.Notificacion;

@RestController
@RequestMapping("/notificaciones")
public class NotificacionController {

    private final NotificacionService notificacionService;

    public NotificacionController(NotificacionService notificacionService) {
        this.notificacionService = notificacionService;
    }

    @GetMapping("/usuario/{idUsuario}")
    public ResponseEntity<List<Notificacion>> obtenerPorUsuario(@PathVariable Long idVendedor) {
        return ResponseEntity.ok(notificacionService.obtenerPorVendedor(idVendedor));
    }

    @PutMapping("/{id}/leer")
    public ResponseEntity<Void> marcarComoLeida(@PathVariable Long id, Long idVendedor) {
        notificacionService.marcarComoLeida(id, idVendedor);
        return ResponseEntity.ok().build();
    }
}