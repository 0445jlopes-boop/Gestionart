package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.LineaPedidoService;
import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.presentation.dto.request.CrearLineaPedidoRequest;

@RestController
@RequestMapping("/lineas-pedido")
public class LineaPedidoController {

    private final LineaPedidoService lineaPedidoService;

    public LineaPedidoController(LineaPedidoService lineaPedidoService) {
        this.lineaPedidoService = lineaPedidoService;
    }

    @PostMapping
    public ResponseEntity<LineaPedido> crear(@RequestBody CrearLineaPedidoRequest request) {

        LineaPedido linea = new LineaPedido();
        linea.setIdPedido(request.getIdPedido());
        linea.setIdArticulo(request.getIdArticulo());
        linea.setCantidad(request.getCantidad());
        linea.setPrecioUnitario(request.getPrecioUnitario());

        return ResponseEntity.ok(lineaPedidoService.crear(linea));
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
}