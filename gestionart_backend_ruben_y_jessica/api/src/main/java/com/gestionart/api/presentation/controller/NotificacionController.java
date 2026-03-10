package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.NotificacionService;
import com.gestionart.api.domain.enums.TipoNotificacion;
import com.gestionart.api.domain.models.Notificacion;

@RestController
@RequestMapping("/notificaciones")
public class NotificacionController {

    private final NotificacionService notificacionService;

    public NotificacionController(NotificacionService notificacionService) {
        this.notificacionService = notificacionService;
    }

    @PostMapping
    public ResponseEntity<Notificacion> crear(
            @RequestParam Long vendedorId,
            @RequestParam TipoNotificacion tipo) {

        return ResponseEntity.ok(
                notificacionService.crearNotificacion(vendedorId, tipo));
    }

    @GetMapping("/vendedor/{id}")
    public ResponseEntity<List<Notificacion>> obtenerPorVendedor(@PathVariable Long id) {
        return ResponseEntity.ok(notificacionService.obtenerPorVendedor(id));
    }

    @PutMapping("/{id}/leer")
    public ResponseEntity<Notificacion> marcarLeida(
            @PathVariable Long id,
            @RequestParam Long vendedorId) {

        return ResponseEntity.ok(
                notificacionService.marcarComoLeida(id, vendedorId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        notificacionService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}