package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.models.Vendedor;

public interface VendedorRepository {
    Vendedor save(Vendedor vendedor);
    Optional<Vendedor> findById(Long id);
    Optional<Vendedor> findByCorreoElectronico(String correoElectronico);
    Optional<Vendedor> findByNombre(String nombre);
    List<Vendedor> findAll();
    void deleteById(Long id);
}
