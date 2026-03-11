package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;
import com.gestionart.api.domain.enums.EstadoPago;
import com.gestionart.api.domain.enums.TipoPago;

public record PagoResponse(
    Long id,
    Long idPedido,
    double cantidad,
    TipoPago tipo,
    EstadoPago estado,
    LocalDateTime fecha
) {}
