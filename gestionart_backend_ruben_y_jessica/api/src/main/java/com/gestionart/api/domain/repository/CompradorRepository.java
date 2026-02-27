package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.models.Comprador;

public interface CompradorRepository {
    Comprador save(Comprador comprador);
    Optional<Comprador> findById(Long id);
    Optional<Comprador> findByCorreoElectronico(String correoElectronico);
    Optional<Comprador> findByNombre(String nombre);
    List<Comprador> findAll();
    void deleteById(Long id);
}
