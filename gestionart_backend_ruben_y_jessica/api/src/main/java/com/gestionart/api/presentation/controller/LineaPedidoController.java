package com.gestionart.api.presentation.controller;

import java.util.List;

import javax.sound.sampled.Line;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.LineaPedidoService;
import com.gestionart.api.common.mapper.LineaPedidoMapper;
import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.presentation.dto.request.LineaPedidoRequest;
import com.gestionart.api.presentation.dto.response.LineaPedidoResponse;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/lineas-pedido")
public class LineaPedidoController {

    private final LineaPedidoService lineaPedidoService;
    private final LineaPedidoMapper lineaPedidoMapper;

    public LineaPedidoController(LineaPedidoService lineaPedidoService) {
        this.lineaPedidoService = lineaPedidoService;
        this.lineaPedidoMapper = new LineaPedidoMapper();
    }

    @PostMapping("/crear")
    public ResponseEntity<LineaPedidoResponse> crear(@RequestBody LineaPedidoRequest request) {
        LineaPedido linea = lineaPedidoMapper.toDomain(request);
                if(linea.getIdArticulo() == null || linea.getCantidad() == 0 || linea.getPrecioUnitario() == 0 || linea.getIdPedido() == null) {
                return ResponseEntity.badRequest().build();
                }

        linea.setIdPedido(request.idPedido());
        linea.setIdArticulo(request.idArticulo());
        linea.setCantidad(request.cantidad());
        linea.setPrecioUnitario(request.precioUnitario());
        LineaPedido creado = lineaPedidoService.crear(linea);
        return ResponseEntity.ok(lineaPedidoMapper.toResponse(creado));
    }

    @PutMapping("/{id}/editar")
    public ResponseEntity<LineaPedidoResponse> actualizar(@PathVariable Long id, @RequestBody LineaPedidoRequest request) {
        LineaPedido linea = lineaPedidoMapper.toDomain(request);
        if(linea.getIdArticulo() == null || linea.getCantidad() == 0 || linea.getPrecioUnitario() == 0 || linea.getIdPedido() == null) {
            return ResponseEntity.badRequest().build();
        }
        linea.setCantidad(request.cantidad());
        linea.setPrecioUnitario(request.precioUnitario());
        LineaPedido actualizado = lineaPedidoService.crear(linea);
        return ResponseEntity.ok(lineaPedidoMapper.toResponse(actualizado));
    }

    @GetMapping("/pedido/{idPedido}")
    public ResponseEntity<LineaPedidoResponse> obtenerPorPedido(@PathVariable Long idPedido){
        return ResponseEntity.ok(
                lineaPedidoMapper.toResponse(lineaPedidoService.obtenerPorPedido(idPedido)));
    }   

    @GetMapping("/{id}")
    public ResponseEntity<LineaPedidoResponse> obtenerPorId(@PathVariable Long id) {

        return ResponseEntity.ok(
                lineaPedidoMapper.toResponse(lineaPedidoService.obtenerPorId(id)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        lineaPedidoService.eliminar(id);
        return ResponseEntity.ok().build();
    }
}