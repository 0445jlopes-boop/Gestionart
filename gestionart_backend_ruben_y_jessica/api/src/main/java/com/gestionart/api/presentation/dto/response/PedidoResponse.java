package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;
import java.util.List;
import com.gestionart.api.domain.enums.EstadoPedido;

public record PedidoResponse(
    Long id,
    Long idComprador,
    LocalDateTime fechaCreacion,
    LocalDateTime fechaConfirmacion,
    EstadoPedido estado,
    List<LineaPedidoResponse> lineas
) {}
