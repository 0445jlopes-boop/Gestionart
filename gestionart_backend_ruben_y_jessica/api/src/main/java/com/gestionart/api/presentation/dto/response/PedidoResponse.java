package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;
import com.gestionart.api.domain.enums.EstadoPedido;

public record PedidoResponse(
    Long id,
    Long idComprador,
    EstadoPedido estado,
    LocalDateTime fecha
) {}
