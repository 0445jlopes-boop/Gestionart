package com.gestionart.api.exception;

import org.springframework.web.bind.annotation.ResponseStatus;

import org.springframework.http.HttpStatus;
@ResponseStatus(HttpStatus.NO_CONTENT)
public class NotfoundByCategoriaException extends RuntimeException {
    public NotfoundByCategoriaException(String categoria) {
        super("No se encontró ningún elemento con la categoría: " + categoria);
    }

}
