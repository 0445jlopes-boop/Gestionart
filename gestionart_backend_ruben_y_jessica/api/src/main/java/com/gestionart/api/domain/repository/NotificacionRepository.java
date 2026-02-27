package com.gestionart.api.domain.repository;

import java.util.List;

import com.gestionart.api.domain.models.Notificacion;
import com.gestionart.api.domain.models.TipoNotificacion;

public interface NotificacionRepository {
    Notificacion save(Notificacion notificacion);
    List<Notificacion> findByVendedorId(Long vendedorId);
    List<Notificacion> findByVendedorIdAndLeidoFalse(Long vendedorId, boolean leido);
    List<Notificacion> findByVendedorIdAndLeidoTrue(Long vendedorId, boolean leido);
    List<Notificacion> findByVendedorIdAndTipo(Long vendedorId, TipoNotificacion tipo);
    void deleteById(Long id);
}

