package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;
import com.gestionart.api.domain.enums.EstadoPago;
import com.gestionart.api.domain.enums.TipoPago;

public record PagoResponse(
    Long id,
    TipoPago tipoPago,
    Long referenciaId,
    double importe,
    EstadoPago estado,
    String referenciaExterna,
    LocalDateTime fecha
) {}