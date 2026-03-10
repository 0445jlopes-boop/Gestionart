package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.AnuncioService;
import com.gestionart.api.domain.models.Anuncio;

@RestController
@RequestMapping("/anuncios")
public class AnuncioController {

    private final AnuncioService anuncioService;

    public AnuncioController(AnuncioService anuncioService) {
        this.anuncioService = anuncioService;
    }

    @PostMapping
    public ResponseEntity<Anuncio> crear(@RequestBody Anuncio anuncio) {
        return ResponseEntity.ok(anuncioService.crear(anuncio));
    }

    @GetMapping
    public ResponseEntity<List<Anuncio>> listar() {
        return ResponseEntity.ok(anuncioService.obtenerTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Anuncio> obtener(@PathVariable Long id) {
        return ResponseEntity.ok(anuncioService.obtenerPorId(id));
    }

    @PutMapping("/{id}/activar")
    public ResponseEntity<Anuncio> activar(@PathVariable Long id) {
        return ResponseEntity.ok(anuncioService.activarPublicidad(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        anuncioService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}