package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.VendedorService;
import com.gestionart.api.domain.models.Vendedor;

@RestController
@RequestMapping("/vendedores")
public class VendedorController {

    private final VendedorService vendedorService;

    public VendedorController(VendedorService vendedorService) {
        this.vendedorService = vendedorService;
    }

    @GetMapping
    public ResponseEntity<List<Vendedor>> listar() {
        return ResponseEntity.ok(vendedorService.listarTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Vendedor> obtener(@PathVariable Long id) {
        return ResponseEntity.ok(vendedorService.obtenerPorId(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Vendedor> actualizar(
            @PathVariable Long id,
            @RequestBody Vendedor vendedor) {

        return ResponseEntity.ok(
                vendedorService.actualizarPerfil(id, vendedor));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        vendedorService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}