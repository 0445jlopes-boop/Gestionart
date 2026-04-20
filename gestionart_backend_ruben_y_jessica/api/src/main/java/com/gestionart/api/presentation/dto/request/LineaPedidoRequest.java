package com.gestionart.api.presentation.dto.request;

public record LineaPedidoRequest(
    Long idPedido,
    Long idArticulo,
    int cantidad,
    double precioUnitario
) {}
