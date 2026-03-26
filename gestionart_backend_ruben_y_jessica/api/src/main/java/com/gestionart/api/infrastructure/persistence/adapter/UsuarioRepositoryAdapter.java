package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.Usuario;
import com.gestionart.api.domain.repository.UsuarioRepository;
import com.gestionart.api.infrastructure.persistence.entity.UsuarioEntity;
import com.gestionart.api.infrastructure.persistence.repository.UsuarioJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class UsuarioRepositoryAdapter implements UsuarioRepository {

    private final UsuarioJpaRepository repository;

    public UsuarioRepositoryAdapter(UsuarioJpaRepository repository) {
        this.repository = repository;
    }

    public Usuario save(Usuario u) {
        return toDomain(repository.save(toEntity(u)));
    }

    public Optional<Usuario> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public Optional<Usuario> findByCorreoElectronico(String correo) {
        return repository.findByCorreoElectronico(correo).map(this::toDomain);
    }

    public Optional<Usuario> findBynombreCorreoElectronico(String nombre) {
        return repository.findByNombre(nombre).map(this::toDomain);
    }

    public List<Usuario> findAll() {
        return repository.findAll().stream().map(this::toDomain).collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    private Usuario toDomain(UsuarioEntity e) {
        return new Usuario(
                e.getId(),
                e.getCorreoElectronico(),
                e.getNombre(),
                e.getImagen(),
                e.getContrasena(),
                e.getRol()
        );
    }

    private UsuarioEntity toEntity(Usuario d) {
        UsuarioEntity e = new UsuarioEntity();
        e.setId(d.getId());
        e.setCorreoElectronico(d.getCorreoElectronico());
        e.setNombre(d.getNombre());
        e.setImagen(d.getImagen());
        e.setContrasena(d.getContrasena());
        e.setRol(d.getRol());
        return e;
    }
}
