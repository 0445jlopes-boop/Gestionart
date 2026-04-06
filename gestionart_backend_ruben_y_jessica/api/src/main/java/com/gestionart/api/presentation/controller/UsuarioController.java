package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.AutenticacionService;
import com.gestionart.api.presentation.dto.request.LoginRequest;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/users")
public class UsuarioController {

    private final AutenticacionService autenticacionService;

    public UsuarioController(AutenticacionService autenticacionService) {
        this.autenticacionService = autenticacionService;
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequest request) {

        String token = autenticacionService.login(
                request.correoElectronico(),
                request.contrasena());

        return ResponseEntity.ok(token);
    }
}