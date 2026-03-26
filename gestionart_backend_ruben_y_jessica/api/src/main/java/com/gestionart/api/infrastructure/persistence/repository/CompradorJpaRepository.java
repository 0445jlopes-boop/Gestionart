package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.CompradorEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CompradorJpaRepository extends JpaRepository<CompradorEntity, Long> {

    Optional<CompradorEntity> findByCorreoElectronico(String correoElectronico);

    Optional<CompradorEntity> findByNombre(String nombre);
}
