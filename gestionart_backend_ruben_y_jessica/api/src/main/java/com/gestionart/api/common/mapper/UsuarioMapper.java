package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.Usuario;
import com.gestionart.api.infrastructure.persistence.entity.UsuarioEntity;
import com.gestionart.api.presentation.dto.request.UsuarioRequest;
import com.gestionart.api.presentation.dto.response.UsuarioResponse;

@Component
public class UsuarioMapper {

    public Usuario toDomain(UsuarioRequest request) {
        return new Usuario(
            null,
            request.correoElectronico(),
            request.nombre(),
            request.imagen(),
            request.contrasena(),
            null
        );
    }

    public UsuarioEntity toEntity(Usuario usuario) {
        return new UsuarioEntity(
            usuario.getId(),
            usuario.getCorreoElectronico(),
            usuario.getNombre(),
            usuario.getImagen(),
            usuario.getContrasena(),
            usuario.getRol()
        );
    }

    public Usuario toDomain(UsuarioEntity entity) {
        return new Usuario(
            entity.getId(),
            entity.getCorreoElectronico(),
            entity.getNombre(),
            entity.getImagen(),
            entity.getContrasena(),
            entity.getRol()
        );
    }

    public UsuarioResponse toResponse(Usuario usuario) {
        return new UsuarioResponse(
            usuario.getId(),
            usuario.getCorreoElectronico(),
            usuario.getNombre(),
            usuario.getImagen(),
            usuario.getRol()
        );
    }
}