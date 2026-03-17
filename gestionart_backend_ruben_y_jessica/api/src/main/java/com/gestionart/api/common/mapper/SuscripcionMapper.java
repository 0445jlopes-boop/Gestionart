package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.Suscripcion;
import com.gestionart.api.infrastructure.persistence.entity.CompradorEntity;
import com.gestionart.api.infrastructure.persistence.entity.SuscripcionEntity;
import com.gestionart.api.presentation.dto.response.SuscripcionResponse;

@Component
public class SuscripcionMapper {

    public SuscripcionEntity toEntity(Suscripcion suscripcion) {

        SuscripcionEntity entity = new SuscripcionEntity();

        entity.setId(suscripcion.getId());
        entity.setFechaInicio(suscripcion.getFechaInicio());
        entity.setFechaFin(suscripcion.getFechaFin());
        entity.setActiva(suscripcion.isActiva());

        CompradorEntity comprador = new CompradorEntity();
        comprador.setId(suscripcion.getIdComprador());

        entity.setComprador(comprador);

        return entity;
    }

    public Suscripcion toDomain(SuscripcionEntity entity) {

        return new Suscripcion(
            entity.getId(),
            entity.getComprador().getId(),
            entity.getFechaInicio(),
            entity.getFechaFin(),
            entity.isActiva()
        );
    }

    public SuscripcionResponse toResponse(Suscripcion suscripcion) {
        return new SuscripcionResponse(suscripcion.getId(), suscripcion.getIdComprador(), suscripcion.getFechaInicio(), suscripcion.getFechaFin(), suscripcion.isActiva());
    }
}
