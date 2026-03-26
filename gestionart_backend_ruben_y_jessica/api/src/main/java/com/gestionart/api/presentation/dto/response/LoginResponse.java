package com.gestionart.api.presentation.dto.response;

public record LoginResponse(
    Long idUsuario,
    String nombre,
    String token,
    String rol
) {}
