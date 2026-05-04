package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.gestionart.api.infrastructure.security.JwtService;
import com.gestionart.api.presentation.dto.request.CompradorRequest;
import com.gestionart.api.presentation.dto.request.LoginRequest;
import com.gestionart.api.presentation.dto.request.VendedorRequest;

import jakarta.validation.Valid;

import com.gestionart.api.application.service.AutenticacionService;
import com.gestionart.api.application.service.UsuarioService;
import com.gestionart.api.domain.enums.Rol;
import com.gestionart.api.domain.enums.TipoCuentaComprador;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.models.Usuario;
import com.gestionart.api.domain.models.Vendedor;

@RestController
@CrossOrigin(origins="*")
@RequestMapping("/auth")
public class AutenticacionController {

    private final JwtService jwtService;
    private final UsuarioService userService;
    private final AutenticacionService autenticacionService;

    

    public AutenticacionController(JwtService jwtService, UsuarioService userService, AutenticacionService autenticacionService) {
        this.jwtService = jwtService;
        this.userService = userService;
        this.autenticacionService = autenticacionService;
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequest request) {

        String token = autenticacionService.login(
                request.correoElectronico(),
                request.contrasena()
        );

        return ResponseEntity.ok(token);
    }

    @PostMapping("/registerComprador")
    public ResponseEntity<String> register(@Valid@RequestBody CompradorRequest request) {

        Comprador comprador = new Comprador();
        comprador.setCorreoElectronico(request.correoElectronico());
        comprador.setContrasena(request.contrasena()); 
        comprador.setNombre(request.nombre());
        comprador.setDireccion(request.direccion());
        comprador.setImagen(request.imagen());
        comprador.setRol(Rol.COMPRADOR);
        comprador.setTipoCuenta(request.tipoCuenta());
        comprador.setFechaInicioPremium(null);
        comprador.setFechaFinPremium(null);
        autenticacionService.registrarComprador(comprador);

        return ResponseEntity.ok("Usuario registrado exitosamente");
    }

    @PostMapping("/registerVendedor")
    public ResponseEntity<String> registerVendedor(@Valid @RequestBody VendedorRequest request) {

        Vendedor vendedor = new Vendedor();
        vendedor.setCorreoElectronico(request.correoElectronico());
        vendedor.setContrasena(request.contrasena()); 
        vendedor.setNombre(request.nombre());
        vendedor.setImagen(request.imagen());
        vendedor.setRol(Rol.VENDEDOR);
        vendedor.setDescripcionPerfil(request.descripcionPerfil());
        autenticacionService.registrarVendedor(vendedor);

        return ResponseEntity.ok("Usuario registrado exitosamente");
    }

    

      
}