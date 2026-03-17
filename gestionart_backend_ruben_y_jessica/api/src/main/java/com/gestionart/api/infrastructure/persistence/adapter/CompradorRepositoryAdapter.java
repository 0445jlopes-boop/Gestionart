package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.repository.CompradorRepository;
import com.gestionart.api.infrastructure.persistence.entity.CompradorEntity;
import com.gestionart.api.infrastructure.persistence.repository.CompradorJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class CompradorRepositoryAdapter implements CompradorRepository {

    private final CompradorJpaRepository repository;

    public CompradorRepositoryAdapter(CompradorJpaRepository repository) {
        this.repository = repository;
    }

    public Comprador save(Comprador c) {
        return toDomain(repository.save(toEntity(c)));
    }

    public Optional<Comprador> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public Optional<Comprador> findByCorreoElectronico(String correo) {
        return repository.findByCorreoElectronico(correo).map(this::toDomain);
    }

    public Optional<Comprador> findByNombre(String nombre) {
        return repository.findByNombre(nombre).map(this::toDomain);
    }

    public List<Comprador> findAll() {
        return repository.findAll().stream().map(this::toDomain).collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    private Comprador toDomain(CompradorEntity e) {
        return new Comprador(
                e.getId(),
                e.getCorreoElectronico(),
                e.getNombre(),
                e.getImagen(),
                e.getContrasena(),
                e.getRol(),
                e.getDireccion(),
                e.getTipoCuenta(),
                e.getFechaInicioPremium(),
                e.getFechaFinPremium()
        );
    }

    private CompradorEntity toEntity(Comprador d) {
        CompradorEntity e = new CompradorEntity();
        e.setId(d.getId());
        e.setCorreoElectronico(d.getCorreoElectronico());
        e.setNombre(d.getNombre());
        e.setImagen(d.getImagen());
        e.setContrasena(d.getContrasena());
        e.setRol(d.getRol());
        e.setDireccion(d.getDireccion());
        e.setTipoCuenta(d.getTipoCuenta());
        e.setFechaInicioPremium(d.getFechaInicioPremium());
        e.setFechaFinPremium(d.getFechaFinPremium());
        return e;
    }
}
