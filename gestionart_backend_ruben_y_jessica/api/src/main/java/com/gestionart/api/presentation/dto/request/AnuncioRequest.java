package com.gestionart.api.presentation.dto.request;

import java.time.LocalDateTime;
import com.gestionart.api.domain.enums.Categoria;

public record AnuncioRequest(
    String titulo,
    Categoria categoria,
    double precio,
    String imagen,
    Long idVendedor
){} 

