package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.LineaPedidoService;
import com.gestionart.api.domain.models.LineaPedido;

@RestController
@RequestMapping("/lineas-pedido")
public class LineaPedidoController {

    private final LineaPedidoService lineaPedidoService;

    public LineaPedidoController(LineaPedidoService lineaPedidoService) {
        this.lineaPedidoService = lineaPedidoService;
    }

    @PostMapping
    public ResponseEntity<LineaPedido> crear(@RequestBody LineaPedido lineaPedido) {
        return ResponseEntity.ok(lineaPedidoService.crear(lineaPedido));
    }

    @GetMapping("/{id}")
    public ResponseEntity<LineaPedido> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(lineaPedidoService.obtenerPorId(id));
    }

    @GetMapping("/pedido/{idPedido}")
    public ResponseEntity<List<LineaPedido>> obtenerPorPedido(@PathVariable Long idPedido) {
        return ResponseEntity.ok(lineaPedidoService.obtenerPorPedido(idPedido));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        lineaPedidoService.eliminar(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/pedido/{idPedido}")
    public ResponseEntity<Void> eliminarPorPedido(@PathVariable Long idPedido) {
        lineaPedidoService.eliminarPorPedido(idPedido);
        return ResponseEntity.noContent().build();
    }
}