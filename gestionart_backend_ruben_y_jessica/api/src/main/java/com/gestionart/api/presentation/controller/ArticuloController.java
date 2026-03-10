package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.ArticuloService;
import com.gestionart.api.domain.models.Articulo;

@RestController
@RequestMapping("/articulos")
public class ArticuloController {

    private final ArticuloService articuloService;

    public ArticuloController(ArticuloService articuloService) {
        this.articuloService = articuloService;
    }

    @PostMapping
    public ResponseEntity<Articulo> crear(@RequestBody Articulo articulo) {
        return ResponseEntity.ok(articuloService.crear(articulo));
    }

    @GetMapping("/disponibles")
    public ResponseEntity<List<Articulo>> listarDisponibles() {
        return ResponseEntity.ok(articuloService.listarDisponibles());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Articulo> obtener(@PathVariable Long id) {
        return ResponseEntity.ok(articuloService.obtenerPorId(id));
    }

    @GetMapping("/vendedor/{id}")
    public ResponseEntity<List<Articulo>> porVendedor(@PathVariable Long id) {
        return ResponseEntity.ok(articuloService.buscarPorVendedor(id));
    }

    @PutMapping("/{id}/stock")
    public ResponseEntity<Articulo> actualizarStock(
            @PathVariable Long id,
            @RequestParam int stock) {

        return ResponseEntity.ok(articuloService.actualizarStock(id, stock));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        articuloService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}