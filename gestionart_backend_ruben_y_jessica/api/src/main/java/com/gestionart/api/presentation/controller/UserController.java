package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.AutenticacionService;
import com.gestionart.api.presentation.dto.request.LoginRequest;

@RestController
@RequestMapping("/users")
public class UserController {

    private final AutenticacionService autenticacionService;

    public UserController(AutenticacionService autenticacionService) {
        this.autenticacionService = autenticacionService;
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequest request) {

        String token = autenticacionService.login(
                request.getCorreo(),
                request.getContrasena());

        return ResponseEntity.ok(token);
    }
}