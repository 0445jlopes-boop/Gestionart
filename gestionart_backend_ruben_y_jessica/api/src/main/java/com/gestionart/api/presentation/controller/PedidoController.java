package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.PedidoService;
import com.gestionart.api.common.mapper.PedidoMapper;
import com.gestionart.api.domain.models.Pedido;
import com.gestionart.api.presentation.dto.request.PedidoRequest;
import com.gestionart.api.presentation.dto.response.PedidoResponse;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/pedidos")
public class PedidoController {

    private final PedidoService pedidoService;
    private final PedidoMapper pedidoMapper;

    public PedidoController(PedidoService pedidoService, PedidoMapper pedidoMapper) {
        this.pedidoService = pedidoService;
        this.pedidoMapper = pedidoMapper;
    }

    @PostMapping
    public ResponseEntity<PedidoResponse> crear(@RequestBody PedidoRequest request) {

        Pedido pedido = pedidoService.crear(request.idComprador());

        return ResponseEntity.ok(pedidoMapper.toResponse(pedido));
    }

    @PutMapping("/{id}/confirmar")
    public ResponseEntity<Void> confirmar(@PathVariable Long id) {

        pedidoService.confirmar(id);
        return ResponseEntity.ok().build();
    }
}