package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.AutenticacionService;
import com.gestionart.api.presentation.dto.request.LoginRequest;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/auth")
public class AutenticacionController {

    private final AutenticacionService autenticacionService;

    public AutenticacionController(AutenticacionService autenticacionService) {
        this.autenticacionService = autenticacionService;
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequest request) {

        return ResponseEntity.ok(
                autenticacionService.login(
                        request.getCorreo(),
                        request.getContrasena()));
    }
}