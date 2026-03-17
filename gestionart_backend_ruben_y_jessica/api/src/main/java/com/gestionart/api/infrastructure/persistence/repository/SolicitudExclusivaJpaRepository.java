package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.SolicitudExclusivaEntity;
import com.gestionart.api.domain.enums.EstadoSolicitud;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SolicitudExclusivaJpaRepository extends JpaRepository<SolicitudExclusivaEntity, Long> {

    List<SolicitudExclusivaEntity> findByComprador_Id(Long idComprador);

    List<SolicitudExclusivaEntity> findByVendedor_Id(Long idVendedor);

    List<SolicitudExclusivaEntity> findByVendedor_IdAndEstado(Long idVendedor, EstadoSolicitud estado);

    List<SolicitudExclusivaEntity> findByComprador_IdAndEstado(Long idComprador, EstadoSolicitud estado);
}
