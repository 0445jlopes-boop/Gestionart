package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.infrastructure.persistence.entity.UsuarioEntity;
import com.gestionart.api.infrastructure.security.JwtService;
import com.gestionart.api.presentation.dto.request.LoginRequest;
import com.gestionart.api.application.service.UsuarioService;

@RestController
@RequestMapping("/auth")
public class AutenticacionController {

    private final JwtService jwtService;
    private final UsuarioService userService;

    public AutenticacionController(JwtService jwtService, UsuarioService userService) {
        this.jwtService = jwtService;
        this.userService = userService;
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequest request) {

        UsuarioEntity usuario = userService.login(
                request.correoElectronico(),
                request.contrasena()
        );

        String token = jwtService.generarToken(
            usuario.getCorreoElectronico(),
            usuario.getRol().name()
        );

        return ResponseEntity.ok(token);
    }
}