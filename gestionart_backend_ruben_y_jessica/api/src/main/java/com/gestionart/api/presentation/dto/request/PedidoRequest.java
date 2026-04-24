package com.gestionart.api.presentation.dto.request;

import java.util.List;

import com.gestionart.api.domain.enums.EstadoPedido;

public record PedidoRequest(
    Long idComprador,
    EstadoPedido estado
) {}