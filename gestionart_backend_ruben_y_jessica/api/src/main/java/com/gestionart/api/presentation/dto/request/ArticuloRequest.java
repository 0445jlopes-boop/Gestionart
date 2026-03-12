package com.gestionart.api.presentation.dto.request;

import com.gestionart.api.domain.enums.Categoria;

public record ArticuloRequest(
    String titulo,
    Categoria categoria,
    double precio,
    String imagen,
    String descripcion,
    int stock,
    Long idVendedor
) {}