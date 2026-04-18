package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.gestionart.api.infrastructure.security.JwtService;
import com.gestionart.api.presentation.dto.request.CompradorRequest;
import com.gestionart.api.presentation.dto.request.LoginRequest;

import jakarta.validation.Valid;

import com.gestionart.api.application.service.AutenticacionService;
import com.gestionart.api.application.service.UsuarioService;
import com.gestionart.api.domain.enums.TipoCuentaComprador;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.models.Usuario;

@RestController
@RequestMapping("/auth")
public class AutenticacionController {

    private final JwtService jwtService;
    private final UsuarioService userService;
    private final AutenticacionService autenticacionService;

    public AutenticacionController(JwtService jwtService, UsuarioService userService) {
        this.jwtService = jwtService;
        this.userService = userService;
        this.autenticacionService = null;
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequest request) {

        Usuario usuario = userService.login(
                request.correoElectronico(),
                request.contrasena()
        );

        String token = jwtService.generarToken(
            usuario.getCorreoElectronico(),
            usuario.getRol().name()
        );

        return ResponseEntity.ok(token);
    }

    @PostMapping("/register")
    public ResponseEntity<String> register(@Valid @RequestBody CompradorRequest request) {

        Comprador comprador = new Comprador();
        comprador.setCorreoElectronico(request.correoElectronico());
        comprador.setContrasena(request.contrasena()); 
        comprador.setNombre(request.nombre());
        comprador.setDireccion(request.direccion());
        comprador.setImagen(request.imagen());
        comprador.setTipoCuenta(TipoCuentaComprador.NORMAL);  
        autenticacionService.registrarComprador(comprador);

        return ResponseEntity.ok("Usuario registrado exitosamente");
    }

      
}