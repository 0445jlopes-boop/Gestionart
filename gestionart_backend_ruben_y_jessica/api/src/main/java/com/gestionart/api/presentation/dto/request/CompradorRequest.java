package com.gestionart.api.presentation.dto.request;

import com.gestionart.api.domain.enums.TipoCuentaComprador;

import jakarta.validation.constraints.*;

public record CompradorRequest(
    
    @Email(message = "El correo electrónico no es válido")
    @NotBlank(message = "El correo electrónico es obligatorio") 
    String correoElectronico,

    @NotBlank(message = "El nombre es obligatorio")    
    String nombre,

    String imagen,

    @NotBlank(message = "La contraseña es obligatoria")
    String contrasena,
    
    @NotBlank(message = "La dirección es obligatoria")
    String direccion,

    TipoCuentaComprador tipoCuenta
) {}
