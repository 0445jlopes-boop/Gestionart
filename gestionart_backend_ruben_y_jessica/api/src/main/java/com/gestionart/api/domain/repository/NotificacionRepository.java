package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.enums.TipoNotificacion;
import com.gestionart.api.domain.models.Notificacion;

public interface NotificacionRepository {
    Notificacion save(Notificacion notificacion);
    Optional<Notificacion> findById(Long id);
    List<Notificacion> findByVendedorId(Long vendedorId);
    List<Notificacion> findByVendedorIdAndLeidoFalse(Long vendedorId, boolean leido);
    List<Notificacion> findByVendedorIdAndLeidoTrue(Long vendedorId, boolean leido);
    List<Notificacion> findByVendedorIdAndTipo(Long vendedorId, TipoNotificacion tipo);
    void deleteById(Long id);
}

