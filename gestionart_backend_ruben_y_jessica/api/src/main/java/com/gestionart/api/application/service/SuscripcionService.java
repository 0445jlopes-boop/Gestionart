package com.gestionart.api.application.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.gestionart.api.domain.models.Suscripcion;
import com.gestionart.api.domain.repository.SuscripcionRepository;

@Service
@Transactional
public class SuscripcionService {

    private final SuscripcionRepository suscripcionRepository;

    public SuscripcionService(SuscripcionRepository suscripcionRepository) {
        this.suscripcionRepository = suscripcionRepository;
    }

    public Suscripcion activarSuscripcion(Long idComprador){

        Suscripcion suscripcion = new Suscripcion();
        suscripcion.setIdComprador(idComprador);
        suscripcion.setFechaInicio(LocalDateTime.now());
        suscripcion.setFechaFin(LocalDateTime.now().plusMonths(1));
        suscripcion.setActiva(true);

        return suscripcionRepository.save(suscripcion);
    }
}
