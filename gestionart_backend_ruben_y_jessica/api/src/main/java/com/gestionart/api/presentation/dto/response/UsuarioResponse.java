package com.gestionart.api.presentation.dto.response;

import com.gestionart.api.domain.enums.Rol;

public record UsuarioResponse(
    Long id,
    String correoElectronico,
    String nombre,
    String imagen,
    Rol rol
) {}
