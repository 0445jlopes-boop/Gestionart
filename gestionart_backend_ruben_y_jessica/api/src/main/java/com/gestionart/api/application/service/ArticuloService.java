package com.gestionart.api.application.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.models.Articulo;
import com.gestionart.api.domain.repository.ArticuloRepository;

@Service
@Transactional
public class ArticuloService {

    private final ArticuloRepository articuloRepository;

    public ArticuloService(ArticuloRepository articuloRepository) {
        this.articuloRepository = articuloRepository;
    }

    public Articulo crear(Articulo articulo) {
        return articuloRepository.save(articulo);
    }

    @Transactional(readOnly = true)
    public List<Articulo> listarDisponibles() {
        return articuloRepository.findByStockGreatherThan(0);
    }

    @Transactional(readOnly = true)
    public Articulo obtenerPorId(Long idArticulo) {
        return articuloRepository.findById(idArticulo)
                .orElseThrow(() -> new RuntimeException("Articulo no encontrado"));
    }

    @Transactional(readOnly = true)
    public List<Articulo> buscarPorVendedor(Long idVendedor) {
        return articuloRepository.findByIdVendedor(idVendedor);
    }

    public Articulo actualizarStock(Long idArticulo, int nuevoStock) {
        Articulo articulo = articuloRepository.findById(idArticulo)
                .orElseThrow(() -> new RuntimeException("Articulo no encontrado"));

        articulo.setStock(nuevoStock);
        return articuloRepository.save(articulo);
    }

    public void eliminar(Long idArticulo) {
        articuloRepository.deleteById(idArticulo);
    }
}