package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.enums.Categoria;
import com.gestionart.api.domain.models.Anuncio;

public interface AnuncioRepository {
    Anuncio save(Anuncio anuncio);
    Optional<Anuncio> findById(Long id);
    List<Anuncio> findAll();
    Optional<Anuncio> findByIdVendedor(Long idVendedor);
    Optional<Anuncio> findByCategoria(Categoria categoria);
    void deleteById(Long id);
}
