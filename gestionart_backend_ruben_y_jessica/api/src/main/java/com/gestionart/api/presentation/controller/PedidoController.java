package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.PedidoService;
import com.gestionart.api.domain.models.Pedido;
import com.gestionart.api.presentation.dto.request.PedidoRequest;
import com.gestionart.api.presentation.dto.response.PedidoResponse;
import com.gestionart.api.presentation.mapper.PedidoMapper;

@RestController
@RequestMapping("/pedidos")
public class PedidoController {

    private final PedidoService pedidoService;

    public PedidoController(PedidoService pedidoService) {
        this.pedidoService = pedidoService;
    }

    @PostMapping
    public ResponseEntity<PedidoResponse> crear(@RequestBody PedidoRequest request) {

        Pedido pedido = pedidoService.crear(request.getIdComprador());

        return ResponseEntity.ok(PedidoMapper.toResponse(pedido));
    }

    @PutMapping("/{id}/confirmar")
    public ResponseEntity<Void> confirmar(@PathVariable Long id) {

        pedidoService.confirmar(id);
        return ResponseEntity.ok().build();
    }
}