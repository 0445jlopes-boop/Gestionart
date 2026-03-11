package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;

public record SuscripcionResponse(
    Long id,
    Long idComprador,
    LocalDateTime fechaInicio,
    LocalDateTime fechaFin,
    boolean activa
) {}
