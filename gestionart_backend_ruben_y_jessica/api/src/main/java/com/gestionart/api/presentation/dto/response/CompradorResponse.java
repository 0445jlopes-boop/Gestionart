package com.gestionart.api.presentation.dto.response;

import java.time.LocalDateTime;
import com.gestionart.api.domain.enums.TipoCuentaComprador;

public record CompradorResponse(
    Long id,
    String correoElectronico,
    String nombre,
    String imagen,
    String direccion,
    TipoCuentaComprador tipoCuenta,
    LocalDateTime fechaInicioPremium,
    LocalDateTime fechaFinPremium
) {}