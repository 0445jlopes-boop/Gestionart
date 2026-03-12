package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.ArticuloService;
import com.gestionart.api.common.mapper.ArticuloMapper;
import com.gestionart.api.domain.models.Articulo;
import com.gestionart.api.presentation.dto.request.ArticuloRequest;
import com.gestionart.api.presentation.dto.response.ArticuloResponse;

@RestController
@RequestMapping("/articulos")
public class ArticuloController {

    private final ArticuloService articuloService;
    private final ArticuloMapper articuloMapper;

    public ArticuloController(ArticuloService articuloService, ArticuloMapper articuloMapper) {
        this.articuloService = articuloService;
        this.articuloMapper = articuloMapper;
    }

    @PostMapping
    public ResponseEntity<ArticuloResponse> crear(@RequestBody ArticuloRequest request) {

        Articulo articulo = articuloMapper.toDomain(request);
        Articulo creado = articuloService.crear(articulo);

        return ResponseEntity.ok(articuloMapper.toResponse(creado));
    }

    @GetMapping
    public ResponseEntity<List<ArticuloResponse>> listarDisponibles() {

        return ResponseEntity.ok(
                articuloService.listarDisponibles()
                        .stream()
                        .map(articuloMapper::toResponse)
                        .toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ArticuloResponse> obtenerPorId(@PathVariable Long id) {

        return ResponseEntity.ok(
                articuloMapper.toResponse(articuloService.obtenerPorId(id)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {

        articuloService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}