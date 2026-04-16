package com.gestionart.api.exception;

import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.http.HttpStatus;
@ResponseStatus(HttpStatus.CONFLICT)
public class ConflictBySecondaryId extends RuntimeException {
    public ConflictBySecondaryId(String input, int caseNumber) {
        super(switch (caseNumber) {
            case 1 -> "El correo electrónico '" + input + "' ya está registrado";
            case 2 -> "El nombre de usuario '" + input + "' ya está registrado";
            default -> "Conflicto por identificador secundario: " + input;
        });


    }
}
