package com.gestionart.api.presentation.dto.response;

import com.gestionart.api.domain.enums.Categoria;

public record ArticuloResponse(
    Long id,
    String titulo,
    Categoria categoria,
    double precio,
    String imagen,
    String descripcion,
    int stock,
    Long idVendedor
) {}