package com.gestionart.api.exception;

import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.http.HttpStatus;

@ResponseStatus(HttpStatus.NO_CONTENT)
public class NotFoundByIdException extends RuntimeException {
    public NotFoundByIdException(Long id) {
        super("No se encontró el recurso con id: " + id);
    }
}
