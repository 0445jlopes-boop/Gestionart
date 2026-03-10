package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.CompradorService;
import com.gestionart.api.domain.models.Comprador;

@RestController
@RequestMapping("/compradores")
public class CompradorController {

    private final CompradorService compradorService;

    public CompradorController(CompradorService compradorService) {
        this.compradorService = compradorService;
    }

    @GetMapping
    public ResponseEntity<List<Comprador>> listar() {
        return ResponseEntity.ok(compradorService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Comprador> obtener(@PathVariable Long id) {
        return ResponseEntity.ok(compradorService.obtenerPorId(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Comprador> actualizar(
            @PathVariable Long id,
            @RequestBody Comprador comprador) {

        return ResponseEntity.ok(compradorService.actualizar(id, comprador));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        compradorService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}