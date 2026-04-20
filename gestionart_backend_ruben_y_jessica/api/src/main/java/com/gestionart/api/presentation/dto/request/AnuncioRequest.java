package com.gestionart.api.presentation.dto.request;

import java.time.LocalDateTime;
import com.gestionart.api.domain.enums.Categoria;

public record AnuncioRequest(
    Long id,
    String titulo,
    Categoria categoria,
    double precio,
    String imagen,
    LocalDateTime fechaInicio,
    LocalDateTime fechaFin,
    Long idVendedor,
    boolean activo
){} 

