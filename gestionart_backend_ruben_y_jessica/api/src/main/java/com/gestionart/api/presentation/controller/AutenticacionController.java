package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.AutenticacionService;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.models.Vendedor;
import com.gestionart.api.presentation.dto.request.LoginRequest;
import com.gestionart.api.presentation.dto.request.RegistroCompradorRequest;
import com.gestionart.api.presentation.dto.request.RegistroVendedorRequest;

@RestController
@RequestMapping("/auth")
public class AutenticacionController {

    private final AutenticacionService autenticacionService;

    public AutenticacionController(AutenticacionService autenticacionService) {
        this.autenticacionService = autenticacionService;
    }

    @PostMapping("/registro/comprador")
    public ResponseEntity<Comprador> registrarComprador(@RequestBody RegistroCompradorRequest request) {

        Comprador comprador = new Comprador();
        comprador.setNombre(request.getNombre());
        comprador.setCorreoElectronico(request.getCorreoElectronico());
        comprador.setContrasena(request.getContrasena());
        comprador.setDireccion(request.getDireccion());

        return ResponseEntity.ok(autenticacionService.registrarComprador(comprador));
    }

    @PostMapping("/registro/vendedor")
    public ResponseEntity<Vendedor> registrarVendedor(@RequestBody RegistroVendedorRequest request) {

        Vendedor vendedor = new Vendedor();
        vendedor.setNombre(request.getNombre());
        vendedor.setCorreoElectronico(request.getCorreoElectronico());
        vendedor.setContrasena(request.getContrasena());
        vendedor.setDescripcionPerfil(request.getDescripcionPerfil());

        return ResponseEntity.ok(autenticacionService.registrarVendedor(vendedor));
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequest request) {

        return ResponseEntity.ok(
                autenticacionService.login(
                        request.getCorreo(),
                        request.getContrasena()));
    }
}