package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.enums.Categoria;
import com.gestionart.api.domain.models.Articulo;

public interface ArticuloRepository {
    Articulo save(Articulo articulo);
    Optional<Articulo> findById(Long id);
    List<Articulo> findAll();
    List<Articulo> findByStockGreatherThan(int stock);
    List<Articulo> findByIdVendedor(Long idVendedor);
    List<Articulo> findByCategoria(Categoria categoria);
    List<Articulo> findByIdVendedorAndCategoria(Long idVendedor, String categoria);
    void deleteById(Long id);
}
