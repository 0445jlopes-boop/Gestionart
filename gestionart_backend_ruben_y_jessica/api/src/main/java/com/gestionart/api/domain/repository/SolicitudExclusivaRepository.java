package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.models.EstadoSolicitud;
import com.gestionart.api.domain.models.SolicitudExclusiva;

public interface SolicitudExclusivaRepository {
    SolicitudExclusiva save(SolicitudExclusiva solicitud);
    Optional<SolicitudExclusiva> findById(Long id);
    List<SolicitudExclusiva> findByIdComprador(Long idComprador);
    List<SolicitudExclusiva> findByIdVendedor(Long idVendedor);
    List<SolicitudExclusiva> findByIdVendedorAndEstado(Long idVendedor, EstadoSolicitud estado);
    List<SolicitudExclusiva> findByIdCompradorAndEstado(Long idComprador, EstadoSolicitud estado);
    List<SolicitudExclusiva> findAll();
    void deleteById(Long id);
}
