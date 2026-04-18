package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.gestionart.api.common.mapper.UsuarioMapper;
import com.gestionart.api.application.service.UsuarioService;
import com.gestionart.api.application.service.AutenticacionService;
import com.gestionart.api.presentation.dto.request.LoginRequest;
import com.gestionart.api.presentation.dto.response.UsuarioResponse;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/users")
public class UsuarioController {

    private final AutenticacionService autenticacionService;
    private final UsuarioService usuarioService;
    private final UsuarioMapper usuarioMapper;
    
    public UsuarioController(AutenticacionService autenticacionService,
                             UsuarioService usuarioService,
                             UsuarioMapper usuarioMapper) {
        this.autenticacionService = autenticacionService;
        this.usuarioService = usuarioService;
        this.usuarioMapper = usuarioMapper;
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequest request) {

        String token = autenticacionService.login(
                request.correoElectronico(),
                request.contrasena());

        return ResponseEntity.ok(token);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UsuarioResponse> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(
                usuarioMapper.toResponse(
                        usuarioService.obtenerPorId(id)));
    }

}