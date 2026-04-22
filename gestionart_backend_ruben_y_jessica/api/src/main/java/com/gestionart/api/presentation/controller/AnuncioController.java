package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.AnuncioService;
import com.gestionart.api.common.mapper.AnuncioMapper;
import com.gestionart.api.domain.enums.Categoria;
import com.gestionart.api.domain.models.Anuncio;
import com.gestionart.api.presentation.dto.request.AnuncioRequest;
import com.gestionart.api.presentation.dto.response.AnuncioResponse;


@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/anuncios")
public class AnuncioController {

    private final AnuncioService anuncioService;
    private final AnuncioMapper anuncioMapper;

    public AnuncioController(AnuncioService anuncioService, AnuncioMapper anuncioMapper) {
        this.anuncioService = anuncioService;
        this.anuncioMapper = anuncioMapper;
    }

    @PostMapping ("/crear")
    public ResponseEntity<AnuncioResponse> crear(@RequestBody AnuncioRequest request) {

        Anuncio anuncio = new Anuncio();
        if(request.titulo() == null || request.categoria() == null || request.precio() == 0 || request.idVendedor() == null) {
            return ResponseEntity.badRequest().build();
        }
        anuncio.setTitulo(request.titulo());
        anuncio.setCategoria(request.categoria());
        anuncio.setPrecio(request.precio());
        anuncio.setIdVendedor(request.idVendedor());
        anuncio.setImagen(request.imagen());

        Anuncio creado = anuncioService.crear(anuncio);

        return ResponseEntity.ok(anuncioMapper.toResponse(creado));
    }

    @GetMapping("/vendedor/{idVendedor}")
    public ResponseEntity<List<AnuncioResponse>> obtenerPorIdVendedor(@PathVariable Long idVendedor) {

        return ResponseEntity.ok(anuncioService.obtenerPorIdVendedor(idVendedor)
                .stream()
                .map(anuncioMapper::toResponse)
                .toList());
    }

    @GetMapping("/categoria/{categoria}")
    public ResponseEntity<List<AnuncioResponse>> obtenerPorCategoria(@PathVariable Categoria categoria) {    

        return ResponseEntity.ok(anuncioService.obtenerPorCategoria(categoria)
                .stream()
                .map(anuncioMapper::toResponse)
                .toList());
    }

    @GetMapping
    public ResponseEntity<List<AnuncioResponse>> listar() {

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

    @PutMapping("/{id}")
    public ResponseEntity<AnuncioResponse> actualizar(@PathVariable Long id, @RequestBody AnuncioRequest request) {

        Anuncio anuncio = new Anuncio();
        anuncio.setTitulo(request.titulo());
        anuncio.setCategoria(request.categoria());
        anuncio.setPrecio(request.precio());
        anuncio.setImagen(request.imagen());

        return ResponseEntity.ok(
                anuncioMapper.toResponse(
                        anuncioService.actualizar(id, anuncio)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {

        anuncioService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}