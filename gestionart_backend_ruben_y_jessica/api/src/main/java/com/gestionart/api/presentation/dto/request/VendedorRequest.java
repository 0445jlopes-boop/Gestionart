package com.gestionart.api.presentation.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record VendedorRequest(
    
    @Email(message = "El correo electrónico no es válido")
    @NotBlank(message = "El correo electrónico es obligatorio")
    String correoElectronico,

    @NotBlank(message = "El nombre es obligatorio")
    String nombre,

    @NotBlank(message = "La imagen es obligatoria")
    String imagen,
    
    @NotBlank(message = "La contraseña es obligatoria")
    String contrasena,

    @NotBlank(message = "La descripción del perfil es obligatoria")
    String descripcionPerfil
) {}