package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.LineaPedidoService;
import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.presentation.dto.request.LineaPedidoRequest;
import com.gestionart.api.presentation.dto.response.LineaPedidoResponse;

@RestController
@RequestMapping("/lineas-pedido")
public class LineaPedidoController {

    private final LineaPedidoService lineaPedidoService;

    public LineaPedidoController(LineaPedidoService lineaPedidoService) {
        this.lineaPedidoService = lineaPedidoService;
    }

    @PostMapping("/{idPedido}")
    public ResponseEntity<LineaPedidoResponse> crear(@PathVariable Long idPedido,
                                                     @RequestBody LineaPedidoRequest request) {

        LineaPedido linea = new LineaPedido(
                null,
                idPedido,
                request.idArticulo(),
                request.cantidad(),
                request.precioUnitario()
        );

        LineaPedido creada = lineaPedidoService.crear(linea);

        return ResponseEntity.ok(
                new LineaPedidoResponse(
                        creada.getId(),
                        creada.getIdArticulo(),
                        creada.getCantidad(),
                        creada.getPrecioUnitario()));
    }

    @GetMapping("/pedido/{idPedido}")
    public ResponseEntity<List<LineaPedidoResponse>> obtenerPorPedido(@PathVariable Long idPedido) {

        return ResponseEntity.ok(
                lineaPedidoService.obtenerPorPedido(idPedido)
                        .stream()
                        .map(l -> new LineaPedidoResponse(
                                l.getId(),
                                l.getIdArticulo(),
                                l.getCantidad(),
                                l.getPrecioUnitario()))
                        .toList());
    }
}