package com.gestionart.api.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.UNAUTHORIZED)
public class InvalidCredentials extends RuntimeException {
    public InvalidCredentials() {
        super("Correo electrnico o contrasea incorrectos");
    }

}
