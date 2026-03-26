package com.gestionart.api.common.mapper;


import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.Notificacion;
import com.gestionart.api.infrastructure.persistence.entity.NotificacionEntity;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import com.gestionart.api.presentation.dto.response.NotificacionResponse;

@Component
public class NotificacionMapper {

    public NotificacionEntity toEntity(Notificacion notificacion) {

        NotificacionEntity entity = new NotificacionEntity();

        entity.setId(notificacion.getId());
        entity.setTipo(notificacion.getTipo());
        entity.setLeido(notificacion.isLeido());
        entity.setFecha(notificacion.getFecha());

        VendedorEntity vendedor = new VendedorEntity();
        vendedor.setId(notificacion.getVendedorId());

        entity.setVendedor(vendedor);

        return entity;
    }

    public Notificacion toDomain(NotificacionEntity entity) {

        return new Notificacion(
            entity.getId(),
            entity.getVendedor().getId(),
            entity.getTipo(),
            entity.isLeido(),
            entity.getFecha()
        );
    }
    public NotificacionResponse toResponse(Notificacion notificacion) {

        return new NotificacionResponse(
                notificacion.getId(),
                notificacion.getVendedorId(), 
                notificacion.getTipo(),
                notificacion.isLeido(),
                notificacion.getFecha()
                
        );
    }
}
