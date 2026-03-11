package com.gestionart.api.presentation.dto.response;

public record ArticuloResponse(
    Long id,
    String nombre,
    String descripcion,
    double precio,
    int stock,
    Long idVendedor
) {}