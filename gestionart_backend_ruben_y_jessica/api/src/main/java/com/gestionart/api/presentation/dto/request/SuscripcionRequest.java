package com.gestionart.api.presentation.dto.request;

import java.time.LocalDateTime;

public record SuscripcionRequest(
    Long idComprador,
    LocalDateTime fechaInicio,
    LocalDateTime fechaFin
) {}
