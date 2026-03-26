package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.UsuarioEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UsuarioJpaRepository extends JpaRepository<UsuarioEntity, Long> {

    Optional<UsuarioEntity> findByCorreoElectronico(String correoElectronico);

    Optional<UsuarioEntity> findByNombre(String nombre);
}
