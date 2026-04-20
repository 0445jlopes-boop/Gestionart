package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.models.Usuario;

public interface UsuarioRepository {
    Usuario save(Usuario usuario);
    Optional<Usuario> findById(Long id);
    Optional<Usuario> findByCorreoElectronico(String correoElectronico);
    Optional<Usuario> findByNombre(String nombre);
    List<Usuario> findAll();
    void deleteById(Long id);
}
