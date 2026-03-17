package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.NotificacionService;
import com.gestionart.api.common.mapper.NotificacionMapper;
import com.gestionart.api.presentation.dto.response.NotificacionResponse;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/notificaciones")
public class NotificacionController {

    private final NotificacionService notificacionService;
    private final NotificacionMapper notificacionMapper;

    public NotificacionController(NotificacionService notificacionService,
                                  NotificacionMapper notificacionMapper) {
        this.notificacionService = notificacionService;
        this.notificacionMapper = notificacionMapper;
    }

    @GetMapping("/vendedor/{idVendedor}")
    public ResponseEntity<List<NotificacionResponse>> obtenerPorVendedor(@PathVariable Long idVendedor) {

        return ResponseEntity.ok(
                notificacionService.obtenerPorVendedor(idVendedor)
                        .stream()
                        .map(notificacionMapper::toResponse)
                        .toList());
    }

    @PutMapping("/{id}/leida/{vendedorId}")
    public ResponseEntity<NotificacionResponse> marcarComoLeida(
            @PathVariable Long id,
            @PathVariable Long vendedorId) {

        return ResponseEntity.ok(
                notificacionMapper.toResponse(
                        notificacionService.marcarComoLeida(id, vendedorId)));
    }
}