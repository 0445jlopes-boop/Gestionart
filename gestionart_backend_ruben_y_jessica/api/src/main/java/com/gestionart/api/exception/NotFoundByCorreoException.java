package com.gestionart.api.exception;

import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.http.HttpStatus;

@ResponseStatus(HttpStatus.NO_CONTENT)
public class NotFoundByCorreoException extends RuntimeException {
    public NotFoundByCorreoException(String correo) {
        super("No se encontró el usuario con correo: " + correo);
    }
}
