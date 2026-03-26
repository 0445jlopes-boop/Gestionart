package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.NotificacionEntity;
import com.gestionart.api.domain.enums.TipoNotificacion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificacionJpaRepository extends JpaRepository<NotificacionEntity, Long> {

    List<NotificacionEntity> findByVendedor_Id(Long vendedorId);

    List<NotificacionEntity> findByVendedor_IdAndLeidoFalse(Long vendedorId);

    List<NotificacionEntity> findByVendedor_IdAndLeidoTrue(Long vendedorId);

    List<NotificacionEntity> findByVendedor_IdAndTipo(Long vendedorId, TipoNotificacion tipo);
}
