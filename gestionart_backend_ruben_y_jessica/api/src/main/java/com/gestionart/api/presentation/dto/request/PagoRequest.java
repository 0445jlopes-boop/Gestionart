package com.gestionart.api.presentation.dto.request;

import com.gestionart.api.domain.enums.TipoPago;

public record PagoRequest(
    TipoPago tipoPago,
    Long referenciaId,
    double importe
) {}