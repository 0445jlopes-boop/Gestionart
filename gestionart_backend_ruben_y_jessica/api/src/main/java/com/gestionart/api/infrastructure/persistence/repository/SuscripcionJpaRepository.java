package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.SuscripcionEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SuscripcionJpaRepository extends JpaRepository<SuscripcionEntity, Long> {

    Optional<SuscripcionEntity> findByComprador_Id(Long idComprador);
}
