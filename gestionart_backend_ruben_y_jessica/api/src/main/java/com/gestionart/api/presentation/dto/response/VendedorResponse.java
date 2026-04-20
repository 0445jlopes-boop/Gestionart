package com.gestionart.api.presentation.dto.response;

public record VendedorResponse(
    Long id,
    String correoElectronico,
    String nombre,
    String imagen,
    String contrasena,
    String descripcionPerfil
) {}
