package com.gestionart.api.presentation.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.LineaPedidoService;
import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.presentation.dto.request.LineaPedidoRequest;
import com.gestionart.api.presentation.dto.response.LineaPedidoResponse;
import com.gestionart.api.presentation.mapper.LineaPedidoMapper;

@RestController
@RequestMapping("/lineas-pedido")
public class LineaPedidoController {

    private final LineaPedidoService lineaPedidoService;

    public LineaPedidoController(LineaPedidoService lineaPedidoService) {
        this.lineaPedidoService = lineaPedidoService;
    }

    @PostMapping
    public ResponseEntity<LineaPedidoResponse> crear(@RequestBody LineaPedidoRequest request) {

        LineaPedido linea = new LineaPedido();
        linea.setIdPedido(request.getIdPedido());
        linea.setIdArticulo(request.getIdArticulo());
        linea.setCantidad(request.getCantidad());
        linea.setPrecioUnitario(request.getPrecioUnitario());

        return ResponseEntity.ok(
                LineaPedidoMapper.toResponse(lineaPedidoService.crear(linea)));
    }

    @GetMapping("/pedido/{idPedido}")
    public ResponseEntity<List<LineaPedidoResponse>> obtenerPorPedido(@PathVariable Long idPedido) {

        return ResponseEntity.ok(
                lineaPedidoService.obtenerPorPedido(idPedido)
                        .stream()
                        .map(LineaPedidoMapper::toResponse)
                        .collect(Collectors.toList()));
    }
}