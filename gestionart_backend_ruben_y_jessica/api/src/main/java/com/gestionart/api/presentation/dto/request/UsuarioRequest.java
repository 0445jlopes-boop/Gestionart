package com.gestionart.api.presentation.dto.request;

public record UsuarioRequest(
    String correoElectronico,
    String nombre,
    String imagen,
    String contrasena
) {}
