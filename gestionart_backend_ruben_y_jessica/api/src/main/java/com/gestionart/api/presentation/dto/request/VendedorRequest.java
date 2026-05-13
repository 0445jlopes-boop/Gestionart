package com.gestionart.api.presentation.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record VendedorRequest(
    
    @Email(message = "El correo electrnico no es vlido")
    @NotBlank(message = "El correo electrnico es obligatorio")
    String correoElectronico,

    @NotBlank(message = "El nombre es obligatorio")
    String nombre,

    String imagen,
    
    @NotBlank(message = "La contrasea es obligatoria")
    String contrasena,

    @NotBlank(message = "La descripcin del perfil es obligatoria")
    String descripcionPerfil
) {}