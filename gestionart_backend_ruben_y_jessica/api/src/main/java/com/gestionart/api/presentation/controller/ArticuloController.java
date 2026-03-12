package com.gestionart.api.presentation.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.ArticuloService;
import com.gestionart.api.domain.models.Articulo;
import com.gestionart.api.presentation.dto.request.ArticuloRequest;
import com.gestionart.api.presentation.dto.response.ArticuloResponse;
import com.gestionart.api.presentation.mapper.ArticuloMapper;

@RestController
@RequestMapping("/articulos")
public class ArticuloController {

    private final ArticuloService articuloService;

    public ArticuloController(ArticuloService articuloService) {
        this.articuloService = articuloService;
    }

    @PostMapping
    public ResponseEntity<ArticuloResponse> crear(@RequestBody ArticuloRequest request) {

        Articulo articulo = new Articulo();
        articulo.setNombre(request.getNombre());
        articulo.setDescripcion(request.getDescripcion());
        articulo.setPrecio(request.getPrecio());
        articulo.setStock(request.getStock());
        articulo.setIdVendedor(request.getIdVendedor());

        return ResponseEntity.ok(
                ArticuloMapper.toResponse(articuloService.crear(articulo)));
    }

    @GetMapping
    public ResponseEntity<List<ArticuloResponse>> listar() {

        return ResponseEntity.ok(
                articuloService.listar()
                        .stream()
                        .map(ArticuloMapper::toResponse)
                        .collect(Collectors.toList()));
    }
}