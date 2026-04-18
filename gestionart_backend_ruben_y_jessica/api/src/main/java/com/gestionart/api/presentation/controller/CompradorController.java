package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.CompradorService;
import com.gestionart.api.common.mapper.CompradorMapper;
import com.gestionart.api.presentation.dto.request.CompradorRequest;
import com.gestionart.api.presentation.dto.response.CompradorResponse;

import jakarta.validation.Valid;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/compradores")
public class CompradorController {

    private final CompradorService compradorService;
    private final CompradorMapper compradorMapper;

    public CompradorController(CompradorService compradorService,
                               CompradorMapper compradorMapper) {
        this.compradorService = compradorService;
        this.compradorMapper = compradorMapper;
    }

    @PutMapping("/{id}")
    public ResponseEntity<CompradorResponse> actualizarDatos(@PathVariable Long id,@Valid @RequestBody CompradorRequest request) {

        return ResponseEntity.ok(
                compradorMapper.toResponse(
                        compradorService.actualizar(id, compradorMapper.toDomain(request))));
    }

    @PutMapping("/{id}/activar-premium")
    public ResponseEntity<Void> activarPremium(@PathVariable Long id) {
        compradorService.activarPremium(id);
        return ResponseEntity.noContent().build();
    }
    @PutMapping("/{id}/desactivar-premium")
    public ResponseEntity<Void> desactivarPremium(@PathVariable Long id) {
        compradorService.desactivarPremium(id);
        return ResponseEntity.noContent().build();
    }



    @GetMapping("/{id}")
    public ResponseEntity<CompradorResponse> obtenerPorId(@PathVariable Long id) {
        
       /*  if(compradorService.obtenerPorId(id) == null) {
            return ResponseEntity.notFound().build();
        } */
        return ResponseEntity.ok(
                compradorMapper.toResponse(
                        compradorService.obtenerPorId(id)));
    }

    @GetMapping("/correo/{correoElectronico}")
    public ResponseEntity<CompradorResponse> obtenerPorCorreo(@PathVariable String correoElectronico) {
        return ResponseEntity.ok(
                compradorMapper.toResponse(
                        compradorService.obtenerPorCorreo(correoElectronico)));
    }
    @GetMapping("/nombre/{nombre}")
    public ResponseEntity<CompradorResponse> obtenerPorNombre(@PathVariable String nombre) {
        return ResponseEntity.ok(
                compradorMapper.toResponse(
                        compradorService.obtenerPorNombre(nombre)));    
    }

    @GetMapping
    public ResponseEntity<List<CompradorResponse>> listar() {

        return ResponseEntity.ok(
                compradorService.listarTodos()
                        .stream()
                        .map(compradorMapper::toResponse)
                        .toList());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {

        compradorService.eliminar(id);
        return ResponseEntity.noContent().build();
    }

}