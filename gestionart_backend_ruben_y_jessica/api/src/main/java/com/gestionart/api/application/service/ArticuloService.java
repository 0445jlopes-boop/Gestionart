package com.gestionart.api.application.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.Categoria;
import com.gestionart.api.domain.models.Articulo;
import com.gestionart.api.domain.repository.ArticuloRepository;
import com.gestionart.api.exception.NotFoundByIdException;

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
                .orElseThrow(() -> new NotFoundByIdException(idArticulo));
    }

    @Transactional(readOnly = true)
    public List<Articulo> buscarPorVendedor(Long idVendedor) {
        return articuloRepository.findByIdVendedor(idVendedor);
    }

    public void eliminar(Long idArticulo) {
        articuloRepository.deleteById(idArticulo);
    }

    public Articulo actualizar(Long id, Articulo articulo) {
        Articulo existente = articuloRepository.findById(id)
                .orElseThrow(() -> new NotFoundByIdException(id));

        if (articulo.getTitulo() != null) {
            existente.setTitulo(articulo.getTitulo());
        }
        if (articulo.getDescripcion() != null) {
            existente.setDescripcion(articulo.getDescripcion());
        }
        if (articulo.getPrecio() > 0) {
            existente.setPrecio(articulo.getPrecio());
        }
        if (articulo.getStock() >= 0) {
            existente.setStock(articulo.getStock());
        }
        if (articulo.getImagen() != null) {
            existente.setImagen(articulo.getImagen());
        }
        if (articulo.getCategoria() != null) {
            existente.setCategoria(articulo.getCategoria());
        }
        if (articulo.getIdVendedor() != null) {
            existente.setIdVendedor(articulo.getIdVendedor());
        }

        return articuloRepository.save(existente);
    }

    public List<Articulo> buscarPorCategoria(Categoria categoria) {
        return articuloRepository.findByCategoria(categoria);
    }
}