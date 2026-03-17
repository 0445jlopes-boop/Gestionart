package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.PagoEntity;
import com.gestionart.api.domain.enums.EstadoPago;
import com.gestionart.api.domain.enums.TipoPago;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PagoJpaRepository extends JpaRepository<PagoEntity, Long> {

    List<PagoEntity> findByTipoPago(TipoPago tipoPago);

    List<PagoEntity> findByReferenciaId(Long referenciaId);

    Optional<PagoEntity> findByReferenciaExterna(String referenciaExterna);

    List<PagoEntity> findByEstado(EstadoPago estado);
}