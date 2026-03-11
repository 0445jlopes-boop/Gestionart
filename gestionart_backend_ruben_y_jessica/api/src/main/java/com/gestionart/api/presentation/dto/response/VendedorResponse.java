package com.gestionart.api.presentation.dto.response;

public record VendedorResponse(
    Long id,
    String nombre,
    String correoElectronico,
    String descripcionPerfil
) {}
