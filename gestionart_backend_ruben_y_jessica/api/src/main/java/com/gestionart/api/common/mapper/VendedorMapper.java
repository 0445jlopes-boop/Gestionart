package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.Vendedor;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import com.gestionart.api.presentation.dto.request.VendedorRequest;
import com.gestionart.api.presentation.dto.response.VendedorResponse;

@Component
public class VendedorMapper {

    public Vendedor toDomain(VendedorRequest request) {

        Vendedor vendedor = new Vendedor();

        vendedor.setCorreoElectronico(request.correoElectronico());
        vendedor.setNombre(request.nombre());
        vendedor.setImagen(request.imagen());
        vendedor.setContrasena(request.contrasena());
        vendedor.setDescripcionPerfil(request.descripcionPerfil());

        return vendedor;
    }

    public VendedorEntity toEntity(Vendedor vendedor) {

        VendedorEntity entity = new VendedorEntity();

        entity.setId(vendedor.getId());
        entity.setCorreoElectronico(vendedor.getCorreoElectronico());
        entity.setNombre(vendedor.getNombre());
        entity.setImagen(vendedor.getImagen());
        entity.setContrasena(vendedor.getContrasena());
        entity.setRol(vendedor.getRol());

        entity.setDescripcionPerfil(vendedor.getDescripcionPerfil());

        return entity;
    }

    public Vendedor toDomain(VendedorEntity entity) {

        return new Vendedor(
            entity.getId(),
            entity.getCorreoElectronico(),
            entity.getNombre(),
            entity.getImagen(),
            entity.getContrasena(),
            entity.getRol(),
            entity.getDescripcionPerfil()
        );
    }

    public VendedorResponse toResponse(Vendedor vendedor) {

        return new VendedorResponse(
            vendedor.getId(),
            vendedor.getCorreoElectronico(),
            vendedor.getNombre(),
            vendedor.getImagen(),
            vendedor.getDescripcionPerfil()
        );
    }
}
