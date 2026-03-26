package com.gestionart.api.presentation.dto.request;

import com.gestionart.api.domain.enums.TipoNotificacion;

public record NotificacionRequest(
    Long idVendedor,
    TipoNotificacion tipo
) {}
