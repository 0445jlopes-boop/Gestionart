package com.gestionart.api.presentation.dto.request;

import java.util.List;

public record PedidoRequest(
    Long idComprador,
    List<LineaPedidoRequest> lineas
) {}