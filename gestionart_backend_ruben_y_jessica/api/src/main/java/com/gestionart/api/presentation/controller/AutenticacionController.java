package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.AutenticacionService;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.models.Vendedor;

@RestController
@RequestMapping("/auth")
public class AutenticacionController {

    private final AutenticacionService autenticacionService;

    public AutenticacionController(AutenticacionService autenticacionService) {
        this.autenticacionService = autenticacionService;
    }

    @PostMapping("/registro/comprador")
    public ResponseEntity<Comprador> registrarComprador(@RequestBody Comprador comprador) {
        return ResponseEntity.ok(autenticacionService.registrarComprador(comprador));
    }

    @PostMapping("/registro/vendedor")
    public ResponseEntity<Vendedor> registrarVendedor(@RequestBody Vendedor vendedor) {
        return ResponseEntity.ok(autenticacionService.registrarVendedor(vendedor));
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(
            @RequestParam String correo,
            @RequestParam String contrasena) {

        return ResponseEntity.ok(autenticacionService.login(correo, contrasena));
    }
}