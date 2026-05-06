package com.gestionart.api.presentation.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.PedidoService;
import com.gestionart.api.common.mapper.PedidoMapper;
import com.gestionart.api.domain.enums.EstadoPedido;
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
        Pedido pedido = pedidoMapper.toDomain(request);
        if(pedido.getEstado() == null) {
           return ResponseEntity.badRequest().build();
        }
        pedido.setEstado(request.estado());
        pedido.setIdComprador(request.idComprador());
        pedido.setLineas(null);
        pedido.setFechaCreacion(LocalDateTime.now());
        pedido.setFechaConfirmacion(null);
        return ResponseEntity.ok(pedidoMapper.toResponse(pedidoService.crear(pedido))) ;
    }

    @PutMapping("/{id}/cancelar")
    public ResponseEntity<Void> cancelar(@PathVariable Long id) {

        pedidoService.cancelar(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/cambiarEstado/{id}")
    public ResponseEntity<Void> cambiarEstado(@PathVariable Long id) {
        pedidoService.cambiarEstado(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}/anadirLinea/{idLinea}")
    public ResponseEntity<Void> anadirLinea(@PathVariable Long id, @PathVariable Long idLinea) {
        Pedido pedido = pedidoService.obtenerPorId(id);
        if(pedido.getEstado() == EstadoPedido.CANCELADO || pedido.getEstado() == EstadoPedido.FINALIZADO) {
            return ResponseEntity.badRequest().build();
        }
        pedido = pedidoService.anadirLinea(id, idLinea);
        return ResponseEntity.ok().build();
    }


    @GetMapping("/{id}")
    public ResponseEntity<PedidoResponse> obtenerPorId(@PathVariable Long id) {

        Pedido pedido = pedidoService.obtenerPorId(id);
        return ResponseEntity.ok(pedidoMapper.toResponse(pedido));
    }

    @GetMapping("/comprador/{idComprador}")
    public ResponseEntity<List<PedidoResponse>> obtenerPorIdComprador(@PathVariable Long idComprador) {
        List<Pedido> pedidos = pedidoService.obtenerPorIdComprador(idComprador);
        if(pedidos.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(
                pedidos.stream()
                        .map(pedidoMapper::toResponse)
                        .toList());
    }

    @GetMapping("/comprador/{idComprador}/estado/{estado}")
    public ResponseEntity<List<PedidoResponse>> obtenerPorIdCompradorYEstado(@PathVariable Long idComprador, @PathVariable EstadoPedido estado) {

        List<Pedido> pedidos = pedidoService.obtenerPorIdCompradorYEstado(idComprador, estado);
        if(pedidos.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(
                pedidos.stream()
                        .map(pedidoMapper::toResponse)
                        .toList());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {

        pedidoService.eliminarPorId(id);
        return ResponseEntity.ok().build();
    }
}
