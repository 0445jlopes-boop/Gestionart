package com.gestionart.api.exception;

import org.springframework.web.bind.annotation.ResponseStatus;

import org.springframework.http.HttpStatus;
@ResponseStatus(HttpStatus.NOT_FOUND)
public class NotFoundByNombreException extends RuntimeException {
    public NotFoundByNombreException(String nombre) {
        super("No se encontró el usuario con nombre: " + nombre);
    }

}
