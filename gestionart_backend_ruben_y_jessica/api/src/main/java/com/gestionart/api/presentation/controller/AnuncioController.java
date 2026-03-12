package com.gestionart.api.presentation.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.AnuncioService;
import com.gestionart.api.domain.models.Anuncio;
import com.gestionart.api.presentation.dto.request.AnuncioRequest;
import com.gestionart.api.presentation.dto.response.AnuncioResponse;
import com.gestionart.api.presentation.mapper.AnuncioMapper;

@RestController
@RequestMapping("/anuncios")
public class AnuncioController {

    private final AnuncioService anuncioService;

    public AnuncioController(AnuncioService anuncioService) {
        this.anuncioService = anuncioService;
    }

    @PostMapping
    public ResponseEntity<AnuncioResponse> crear(@RequestBody AnuncioRequest request) {

        Anuncio anuncio = new Anuncio();
        anuncio.setTitulo(request.getTitulo());
        anuncio.setCategoria(request.getCategoria());
        anuncio.setPrecio(request.getPrecio());
        anuncio.setImagen(request.getImagen());
        anuncio.setIdVendedor(request.getIdVendedor());

        Anuncio creado = anuncioService.crear(anuncio);

        return ResponseEntity.ok(AnuncioMapper.toResponse(creado));
    }

    @GetMapping
    public ResponseEntity<List<AnuncioResponse>> obtenerTodos() {

        return ResponseEntity.ok(
                anuncioService.obtenerTodos()
                        .stream()
                        .map(AnuncioMapper::toResponse)
                        .collect(Collectors.toList()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AnuncioResponse> obtenerPorId(@PathVariable Long id) {

        return ResponseEntity.ok(
                AnuncioMapper.toResponse(anuncioService.obtenerPorId(id)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {

        anuncioService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}