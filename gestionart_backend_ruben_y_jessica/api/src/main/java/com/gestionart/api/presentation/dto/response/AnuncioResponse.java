package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;
import com.gestionart.api.domain.enums.Categoria;

public record AnuncioResponse(
    Long id,
    String titulo,
    Categoria categoria,
    double precio,
    String imagen,
    LocalDateTime fechaInicio,
    LocalDateTime fechaFin,
    Long idVendedor,
    boolean activo
) {}
