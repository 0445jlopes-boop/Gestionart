package com.gestionart.api.presentation.dto.request;

public record SolicitudExclusivaRequest(
    Long idComprador,
    Long idArticulo,
    Long idVendedor,
    String mensaje
) {}