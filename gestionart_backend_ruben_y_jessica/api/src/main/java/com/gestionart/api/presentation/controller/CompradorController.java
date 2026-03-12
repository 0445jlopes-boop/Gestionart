package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.CompradorService;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.presentation.dto.request.CompradorRequest;
import com.gestionart.api.presentation.dto.response.CompradorResponse;
import com.gestionart.api.presentation.mapper.CompradorMapper;

@RestController
@RequestMapping("/compradores")
public class CompradorController {

    private final CompradorService compradorService;

    public CompradorController(CompradorService compradorService) {
        this.compradorService = compradorService;
    }

    @PostMapping
    public ResponseEntity<CompradorResponse> crear(@RequestBody CompradorRequest request) {

        Comprador comprador = new Comprador();
        comprador.setNombre(request.getNombre());
        comprador.setCorreoElectronico(request.getCorreoElectronico());
        comprador.setContrasena(request.getContrasena());
        comprador.setDireccion(request.getDireccion());

        return ResponseEntity.ok(
                CompradorMapper.toResponse(compradorService.crear(comprador)));
    }
}