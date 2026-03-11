package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;

public record NotificacionResponse(
    Long id,
    Long idUsuario,
    String mensaje,
    boolean leida,
    LocalDateTime fecha
) {}
