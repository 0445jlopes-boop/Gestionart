package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.VendedorService;
import com.gestionart.api.common.mapper.VendedorMapper;
import com.gestionart.api.presentation.dto.request.VendedorRequest;
import com.gestionart.api.presentation.dto.response.VendedorResponse;

@CrossOrigin(origins = "*")
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

    @PutMapping("/{id}")
    public ResponseEntity<VendedorResponse> actualizarDatos(@PathVariable Long id,@RequestBody VendedorRequest request) {

        return ResponseEntity.ok(
                vendedorMapper.toResponse(
                        vendedorService.actualizar(id, vendedorMapper.toDomain(request))));
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
    public ResponseEntity<VendedorResponse> obtenerPorId(@PathVariable Long id) {

        return ResponseEntity.ok(
                vendedorMapper.toResponse(
                        vendedorService.obtenerPorId(id)));
    }

    @GetMapping("/correo/{correoElectronico}")
    public ResponseEntity<VendedorResponse> obtenerPorCorreo(@PathVariable String correoElectronico) {

        return ResponseEntity.ok(
                vendedorMapper.toResponse(
                        vendedorService.obtenerPorCorreo(correoElectronico)));
    }

    @GetMapping("/nombre/{nombre}")
    public ResponseEntity<VendedorResponse> obtenerPorNombre(@PathVariable String nombre) {

        return ResponseEntity.ok(
                vendedorMapper.toResponse(
                        vendedorService.obtenerPorNombre(nombre)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        vendedorService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}