package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.VendedorService;
import com.gestionart.api.common.mapper.VendedorMapper;
import com.gestionart.api.presentation.dto.response.VendedorResponse;

@RestController
@RequestMapping("/vendedores")
public class VendedorController {

    private final VendedorService vendedorService;
    private final VendedorMapper vendedorMapper;

    public VendedorController(VendedorService vendedorService,
                              VendedorMapper vendedorMapper) {
        this.vendedorService = vendedorService;
        this.vendedorMapper = vendedorMapper;
    }

    @GetMapping
    public ResponseEntity<List<VendedorResponse>> listar() {

        return ResponseEntity.ok(
                vendedorService.listarTodos()
                        .stream()
                        .map(vendedorMapper::toResponse)
                        .toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<VendedorResponse> obtener(@PathVariable Long id) {

        return ResponseEntity.ok(
                vendedorMapper.toResponse(
                        vendedorService.obtenerPorId(id)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {

        vendedorService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}