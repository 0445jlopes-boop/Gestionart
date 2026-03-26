package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;
import com.gestionart.api.domain.enums.EstadoSolicitud;

public record SolicitudExclusivaResponse(
    Long id,
    Long idComprador,
    Long idArticulo,
    Long idVendedor,
    String mensaje,
    EstadoSolicitud estado,
    LocalDateTime fecha
) {}