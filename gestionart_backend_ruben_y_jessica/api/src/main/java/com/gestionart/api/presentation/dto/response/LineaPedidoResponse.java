package com.gestionart.api.presentation.dto.response;

public record LineaPedidoResponse(
    Long id,
    Long idArticulo,
    int cantidad,
    double precioUnitario
) {}