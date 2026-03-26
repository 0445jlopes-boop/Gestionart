package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.infrastructure.persistence.entity.CompradorEntity;
import com.gestionart.api.presentation.dto.request.CompradorRequest;
import com.gestionart.api.presentation.dto.response.CompradorResponse;

@Component
public class CompradorMapper {

    // DTO -> Domain
    public Comprador toDomain(CompradorRequest request) {

        Comprador comprador = new Comprador();

        comprador.setCorreoElectronico(request.correoElectronico());
        comprador.setNombre(request.nombre());
        comprador.setImagen(request.imagen());
        comprador.setContrasena(request.contrasena());
        comprador.setDireccion(request.direccion());
        comprador.setTipoCuenta(request.tipoCuenta());

        return comprador;
    }

    // Domain -> Entity
    public CompradorEntity toEntity(Comprador comprador) {

        CompradorEntity entity = new CompradorEntity();

        entity.setId(comprador.getId());
        entity.setCorreoElectronico(comprador.getCorreoElectronico());
        entity.setNombre(comprador.getNombre());
        entity.setImagen(comprador.getImagen());
        entity.setContrasena(comprador.getContrasena());
        entity.setRol(comprador.getRol());

        entity.setDireccion(comprador.getDireccion());
        entity.setTipoCuenta(comprador.getTipoCuenta());
        entity.setFechaInicioPremium(comprador.getFechaInicioPremium());
        entity.setFechaFinPremium(comprador.getFechaFinPremium());

        return entity;
    }

    // Entity -> Domain
    public Comprador toDomain(CompradorEntity entity) {

        return new Comprador(
            entity.getId(),
            entity.getCorreoElectronico(),
            entity.getNombre(),
            entity.getImagen(),
            entity.getContrasena(),
            entity.getRol(),
            entity.getDireccion(),
            entity.getTipoCuenta(),
            entity.getFechaInicioPremium(),
            entity.getFechaFinPremium()
        );
    }

    // Domain -> Response
    public CompradorResponse toResponse(Comprador comprador) {

        return new CompradorResponse(
            comprador.getId(),
            comprador.getCorreoElectronico(),
            comprador.getNombre(),
            comprador.getImagen(),
            comprador.getDireccion(),
            comprador.getTipoCuenta(),
            comprador.getFechaInicioPremium(),
            comprador.getFechaFinPremium()
        );
    }
}
