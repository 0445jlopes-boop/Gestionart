package com.gestionart.api.application.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.gestionart.api.infrastructure.persistence.entity.UsuarioEntity;
import com.gestionart.api.infrastructure.persistence.repository.UsuarioJpaRepository;

@Service
public class UsuarioService {

    private final UsuarioJpaRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UsuarioService(UsuarioJpaRepository userRepository,
                       PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public UsuarioEntity login(String email, String password) {

        UsuarioEntity usuario = userRepository.findByCorreoElectronico(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        if (!passwordEncoder.matches(password, usuario.getContrasena())) {
            throw new RuntimeException("Contraseña incorrecta");
        }

        return usuario;
    }
}
