package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.Pago;
import com.gestionart.api.infrastructure.persistence.entity.PagoEntity;

@Component
public class PagoMapper {

    public PagoEntity toEntity(Pago pago) {

        PagoEntity entity = new PagoEntity();

        entity.setId(pago.getId());
        entity.setTipoPago(pago.getTipoPago());
        entity.setReferenciaId(pago.getReferenciaId());
        entity.setImporte(pago.getImporte());
        entity.setEstado(pago.getEstado());
        entity.setReferenciaExterna(pago.getReferenciaExterna());
        entity.setFecha(pago.getFecha());

        return entity;
    }

    public Pago toDomain(PagoEntity entity) {

        return new Pago(
            entity.getId(),
            entity.getTipoPago(),
            entity.getReferenciaId(),
            entity.getImporte(),
            entity.getEstado(),
            entity.getReferenciaExterna(),
            entity.getFecha()
        );
    }
}