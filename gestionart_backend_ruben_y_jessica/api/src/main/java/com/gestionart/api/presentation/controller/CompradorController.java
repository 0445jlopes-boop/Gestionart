package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.CompradorService;
import com.gestionart.api.common.mapper.CompradorMapper;
import com.gestionart.api.presentation.dto.response.CompradorResponse;

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