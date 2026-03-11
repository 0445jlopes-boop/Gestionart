package com.gestionart.api.presentation.dto.response;

public record CompradorResponse(
    Long id,
    String nombre,
    String correoElectronico,
    String direccion
) {}