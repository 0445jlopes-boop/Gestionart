package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;
import com.gestionart.api.domain.enums.TipoNotificacion;

public record NotificacionResponse(
    Long id,
    Long idVendedor,
    TipoNotificacion tipo,
    boolean leido,
    LocalDateTime fecha
) {}