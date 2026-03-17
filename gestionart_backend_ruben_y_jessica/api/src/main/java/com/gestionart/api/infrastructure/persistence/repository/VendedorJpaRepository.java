package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface VendedorJpaRepository extends JpaRepository<VendedorEntity, Long> {

    Optional<VendedorEntity> findByCorreoElectronico(String correoElectronico);

    Optional<VendedorEntity> findByNombre(String nombre);
}
