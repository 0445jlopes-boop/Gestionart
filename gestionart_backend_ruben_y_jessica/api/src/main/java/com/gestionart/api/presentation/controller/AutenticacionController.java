package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.infrastructure.security.JwtService;
import com.gestionart.api.application.service.UserService;
import com.gestionart.api.domain.models.User;

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

        User user = userService.login(
                request.getCorreoElectronico(),
                request.getContrasena()
        );

        String token = jwtService.generarToken(
                user.getId(),
                user.getRol()
        );

        return ResponseEntity.ok(token);
    }
}