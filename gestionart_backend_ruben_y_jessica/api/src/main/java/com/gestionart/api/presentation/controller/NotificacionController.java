package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.NotificacionService;

@RestController
@RequestMapping("/notificaciones")
public class NotificacionController {

    private final NotificacionService notificacionService;

    public NotificacionController(NotificacionService notificacionService) {
        this.notificacionService = notificacionService;
    }

    @PostMapping("/pedido-confirmado/{idComprador}")
    public ResponseEntity<Void> notificarPedido(@PathVariable Long idComprador) {

        notificacionService.notificarPedidoConfirmado(idComprador);

        return ResponseEntity.ok().build();
    }
}