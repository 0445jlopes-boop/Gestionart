package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.NotificacionService;
import com.gestionart.api.common.mapper.NotificacionMapper;
import com.gestionart.api.domain.enums.TipoNotificacion;
import com.gestionart.api.presentation.dto.request.NotificacionRequest;
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

    @PostMapping
    public ResponseEntity<NotificacionResponse> crearNotificacion(
            @RequestBody NotificacionRequest notificacionRequest) {

        return ResponseEntity.ok(
                notificacionMapper.toResponse(
                        notificacionService.crearNotificacion(notificacionRequest.idVendedor(), notificacionRequest.tipo())));
    }

    @GetMapping("/vendedor/{idVendedor}")
    public ResponseEntity<List<NotificacionResponse>> obtenerPorVendedor(@PathVariable Long idVendedor) {

        return ResponseEntity.ok(
                notificacionService.obtenerPorVendedor(idVendedor)
                        .stream()
                        .map(notificacionMapper::toResponse)
                        .toList());
    }

    @GetMapping("/vendedor/{idVendedor}/no-leidas")
    public ResponseEntity<List<NotificacionResponse>> obtenerNoLeidas(@PathVariable Long idVendedor) {

        return ResponseEntity.ok(
                notificacionService.obtenerNoLeidas(idVendedor)
                        .stream()
                        .map(notificacionMapper::toResponse)
                        .toList());
    }

    @GetMapping("/vendedor/{idVendedor}/leidas")
    public ResponseEntity<List<NotificacionResponse>> obtenerLeidas(@PathVariable Long idVendedor) {

        return ResponseEntity.ok(
                notificacionService.obtenerLeidas(idVendedor)
                        .stream()
                        .map(notificacionMapper::toResponse)
                        .toList());
    }       

    @GetMapping("/vendedor/{idVendedor}/tipo/{tipo}")
    public ResponseEntity<List<NotificacionResponse>> obtenerPorTipo(     
            @PathVariable Long idVendedor,
            @PathVariable TipoNotificacion tipo) {

        return ResponseEntity.ok(
                notificacionService.obtenerPorVendedorYTipo(idVendedor, tipo)
                        .stream()
                        .map(notificacionMapper::toResponse)
                        .toList());
    } 
    
    @GetMapping("/{id}")
    public ResponseEntity<NotificacionResponse> obtenerPorId(@PathVariable Long id) {

        return ResponseEntity.ok(
                notificacionMapper.toResponse(
                        notificacionService.obtenerPorId(id)));
    }

    @PutMapping("/{id}/leida/{vendedorId}")
    public ResponseEntity<NotificacionResponse> marcarComoLeida(
            @PathVariable Long id,
            @PathVariable Long vendedorId) {

        return ResponseEntity.ok(
                notificacionMapper.toResponse(
                        notificacionService.marcarComoLeida(id)));
    }

    @PutMapping("/vendedor/{vendedorId}/leidas")
    public ResponseEntity<Void> marcarTodasComoLeidas(@PathVariable Long vendedorId) {

        notificacionService.marcarTodasComoLeidas(vendedorId);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarNotificacion(@PathVariable Long id) {
        notificacionService.eliminar(id);
        return ResponseEntity.noContent().build();

    }
}