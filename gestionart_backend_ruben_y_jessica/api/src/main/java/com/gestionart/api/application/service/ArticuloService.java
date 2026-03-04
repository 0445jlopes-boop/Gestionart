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

    public List<Articulo> listarDisponibles() {
        return articuloRepository.findByStockGreatherThan(0);
    }

    public List<Articulo> buscarPorVendedor(Long idVendedor) {
        return articuloRepository.findByIdVendedor(idVendedor);
    }

    public Articulo actualizarStock(Long idArticulo, int nuevoStock) {

        Articulo articulo = articuloRepository.findById(idArticulo)
                .orElseThrow(() -> new RuntimeException("No encontrado"));

        articulo.setStock(nuevoStock);
        return articuloRepository.save(articulo);
    }
}