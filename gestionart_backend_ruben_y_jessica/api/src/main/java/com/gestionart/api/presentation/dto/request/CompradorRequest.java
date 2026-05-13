package com.gestionart.api.presentation.dto.request;

import com.gestionart.api.domain.enums.TipoCuentaComprador;

import jakarta.validation.constraints.*;

public record CompradorRequest(
    
    @Email(message = "El correo electrnico no es vlido")
    @NotBlank(message = "El correo electrnico es obligatorio") 
    String correoElectronico,

    @NotBlank(message = "El nombre es obligatorio")    
    String nombre,

    String imagen,

    @NotBlank(message = "La contrasea es obligatoria")
    String contrasena,
    
    @NotBlank(message = "La direccin es obligatoria")
    String direccion,

    TipoCuentaComprador tipoCuenta
) {}
