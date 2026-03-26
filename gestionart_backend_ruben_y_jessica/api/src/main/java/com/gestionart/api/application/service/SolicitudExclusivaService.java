package com.gestionart.api.application.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.EstadoSolicitud;
import com.gestionart.api.domain.models.SolicitudExclusiva;
import com.gestionart.api.domain.repository.SolicitudExclusivaRepository;

@Service
@Transactional
public class SolicitudExclusivaService {

    private final SolicitudExclusivaRepository repository;

    public SolicitudExclusivaService(SolicitudExclusivaRepository repository) {
        this.repository = repository;
    }

    public SolicitudExclusiva crear(SolicitudExclusiva solicitud) {

        solicitud.setFecha(LocalDateTime.now());
        solicitud.setEstado(EstadoSolicitud.PENDIENTE);

        return repository.save(solicitud);
    }
}