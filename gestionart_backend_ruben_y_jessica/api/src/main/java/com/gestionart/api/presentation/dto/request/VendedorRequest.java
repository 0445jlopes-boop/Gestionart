package com.gestionart.api.presentation.dto.request;

public record VendedorRequest(
    String correoElectronico,
    String nombre,
    String imagen,
    String contrasena,
    String descripcionPerfil
) {}