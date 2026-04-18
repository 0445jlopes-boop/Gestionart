package com.gestionart.api.exception;

import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.http.HttpStatus;

@ResponseStatus(HttpStatus.BAD_REQUEST)
public class BadRequestData extends RuntimeException {
    public BadRequestData(String message) {
        super("Los datos de " + message + " son inválidos");
    }

}
