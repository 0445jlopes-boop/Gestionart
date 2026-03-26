package com.gestionart.api.presentation.dto.request;

import com.gestionart.api.domain.enums.TipoCuentaComprador;

public record CompradorRequest(
    String correoElectronico,
    String nombre,
    String imagen,
    String contrasena,
    String direccion,
    TipoCuentaComprador tipoCuenta
) {}
