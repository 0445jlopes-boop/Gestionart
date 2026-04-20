package com.gestionart.api.application.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.gestionart.api.domain.models.Usuario;
import com.gestionart.api.domain.repository.UsuarioRepository;
import com.gestionart.api.exception.BadRequestPassword;
import com.gestionart.api.exception.ConflictBySecondaryId;
import com.gestionart.api.exception.NotFoundByCorreoException;
import com.gestionart.api.exception.NotFoundByIdException;
@Service
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    public UsuarioService(PasswordEncoder passwordEncoder, UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
    }

   public Usuario login(String email, String password) {

    Usuario usuario = usuarioRepository
            .findByCorreoElectronico(email)
            .orElseThrow(() -> new NotFoundByCorreoException(email));

    if (!passwordEncoder.matches(password, usuario.getContrasena())) {
        throw new BadRequestPassword();
    }

    return usuario;
}

   public Usuario obtenerPorId(Long id) {
    return usuarioRepository.findById(id)
            .orElseThrow(() -> new NotFoundByIdException(id));
   }
}
