package com.gestionart.api.presentation.dto.request;

public record LineaPedidoRequest(
    Long idArticulo,
    int cantidad,
    double precioUnitario
) {}
