package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.AnuncioService;
import com.gestionart.api.common.mapper.AnuncioMapper;
import com.gestionart.api.domain.models.Anuncio;
import com.gestionart.api.presentation.dto.request.AnuncioRequest;
import com.gestionart.api.presentation.dto.response.AnuncioResponse;

@RestController
@RequestMapping("/anuncios")
public class AnuncioController {

    private final AnuncioService anuncioService;
    private final AnuncioMapper anuncioMapper;

    public AnuncioController(AnuncioService anuncioService, AnuncioMapper anuncioMapper) {
        this.anuncioService = anuncioService;
        this.anuncioMapper = anuncioMapper;
    }

    @PostMapping
    public ResponseEntity<AnuncioResponse> crear(@RequestBody AnuncioRequest request) {

        Anuncio anuncio = anuncioMapper.toDomain(request);
        Anuncio creado = anuncioService.crear(anuncio);

        return ResponseEntity.ok(anuncioMapper.toResponse(creado));
    }

    @GetMapping
    public ResponseEntity<List<AnuncioResponse>> obtenerTodos() {

        return ResponseEntity.ok(
                anuncioService.obtenerTodos()
                        .stream()
                        .map(anuncioMapper::toResponse)
                        .toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<AnuncioResponse> obtenerPorId(@PathVariable Long id) {

        return ResponseEntity.ok(
                anuncioMapper.toResponse(anuncioService.obtenerPorId(id)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {

        anuncioService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}