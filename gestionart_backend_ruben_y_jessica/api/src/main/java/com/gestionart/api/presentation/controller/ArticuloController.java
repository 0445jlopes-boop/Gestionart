package com.gestionart.api.presentation.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.ArticuloService;
import com.gestionart.api.common.mapper.ArticuloMapper;
import com.gestionart.api.domain.enums.Categoria;
import com.gestionart.api.domain.enums.EstadoPedido;
import com.gestionart.api.domain.models.Articulo;
import com.gestionart.api.presentation.dto.request.ArticuloRequest;
import com.gestionart.api.presentation.dto.response.ArticuloResponse;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/articulos")
public class ArticuloController {

    private final ArticuloService articuloService;
    private final ArticuloMapper articuloMapper;

    public ArticuloController(ArticuloService articuloService, ArticuloMapper articuloMapper) {
        this.articuloService = articuloService;
        this.articuloMapper = articuloMapper;
    }

    @PutMapping("/{id}")
    public ResponseEntity<ArticuloResponse> actualizar(@PathVariable Long id, @RequestBody ArticuloRequest request) {

        Articulo articulo = articuloMapper.toDomain(request);
        Articulo actualizado = articuloService.actualizar(id, articulo);

        return ResponseEntity.ok(articuloMapper.toResponse(actualizado));
    }

    @PostMapping("/crear")
    public ResponseEntity<ArticuloResponse> crear(@RequestBody ArticuloRequest request) {

       Articulo articulo = articuloMapper.toDomain(request);
       if(articulo.getTitulo() == null || articulo.getCategoria() == null || articulo.getPrecio() == 0 || articulo.getIdVendedor() == null) {
            return ResponseEntity.badRequest().build();
        }
        articulo.setCategoria(request.categoria());
        articulo.setPrecio(request.precio());
        articulo.setImagen(request.imagen());
        articulo.setDescripcion(request.descripcion());
        articulo.setStock(request.stock());
        articulo.setIdVendedor(request.idVendedor());
        articulo.setTitulo(request.titulo());
        Articulo creado = articuloService.crear(articulo);

        return ResponseEntity.ok(articuloMapper.toResponse(creado));
    }

    @GetMapping
    public ResponseEntity<List<ArticuloResponse>> listarDisponibles() {

        return ResponseEntity.ok(
                articuloService.listarDisponibles()
                        .stream()
                        .map(articuloMapper::toResponse)
                        .toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ArticuloResponse> obtenerPorId(@PathVariable Long id) {

        return ResponseEntity.ok(
                articuloMapper.toResponse(articuloService.obtenerPorId(id)));
    }

    @GetMapping("/vendedor/{idVendedor}")
    public ResponseEntity<List<ArticuloResponse>> buscarPorVendedor(@PathVariable Long idVendedor) {

        return ResponseEntity.ok(
                articuloService.buscarPorVendedor(idVendedor)
                        .stream()
                        .map(articuloMapper::toResponse)
                        .toList());
    }       

    @GetMapping("/categoria/{categoria}")
    public ResponseEntity<List<ArticuloResponse>> buscarPorCategoria(@RequestParam("categoria") Categoria categoria) {

        return ResponseEntity.ok(
                articuloService.buscarPorCategoria(categoria)
                        .stream()
                        .map(articuloMapper::toResponse)
                        .toList());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {

        articuloService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}