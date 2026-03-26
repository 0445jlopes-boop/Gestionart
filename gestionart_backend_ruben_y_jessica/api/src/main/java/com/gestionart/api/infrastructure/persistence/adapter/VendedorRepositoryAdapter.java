package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.Vendedor;
import com.gestionart.api.domain.repository.VendedorRepository;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import com.gestionart.api.infrastructure.persistence.repository.VendedorJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class VendedorRepositoryAdapter implements VendedorRepository {

    private final VendedorJpaRepository repository;

    public VendedorRepositoryAdapter(VendedorJpaRepository repository) {
        this.repository = repository;
    }

    public Vendedor save(Vendedor v) {
        return toDomain(repository.save(toEntity(v)));
    }

    public Optional<Vendedor> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public Optional<Vendedor> findByCorreoElectronico(String correo) {
        return repository.findByCorreoElectronico(correo).map(this::toDomain);
    }

    public Optional<Vendedor> findByNombre(String nombre) {
        return repository.findByNombre(nombre).map(this::toDomain);
    }

    public List<Vendedor> findAll() {
        return repository.findAll().stream().map(this::toDomain).collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    private Vendedor toDomain(VendedorEntity e) {
        return new Vendedor(
                e.getId(),
                e.getCorreoElectronico(),
                e.getNombre(),
                e.getImagen(),
                e.getContrasena(),
                e.getRol(),
                e.getDescripcionPerfil()
        );
    }

    private VendedorEntity toEntity(Vendedor d) {
        VendedorEntity e = new VendedorEntity();
        e.setId(d.getId());
        e.setCorreoElectronico(d.getCorreoElectronico());
        e.setNombre(d.getNombre());
        e.setImagen(d.getImagen());
        e.setContrasena(d.getContrasena());
        e.setRol(d.getRol());
        e.setDescripcionPerfil(d.getDescripcionPerfil());
        return e;
    }
}