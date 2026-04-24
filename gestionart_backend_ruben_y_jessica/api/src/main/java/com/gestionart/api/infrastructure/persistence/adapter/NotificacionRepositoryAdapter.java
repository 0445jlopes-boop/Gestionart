package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.Notificacion;
import com.gestionart.api.domain.repository.NotificacionRepository;
import com.gestionart.api.infrastructure.persistence.entity.NotificacionEntity;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import com.gestionart.api.infrastructure.persistence.repository.NotificacionJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class NotificacionRepositoryAdapter implements NotificacionRepository {

    private final NotificacionJpaRepository repository;

    public NotificacionRepositoryAdapter(NotificacionJpaRepository repository) {
        this.repository = repository;
    }

    public Notificacion save(Notificacion n) {
        return toDomain(repository.save(toEntity(n)));
    }

    public List<Notificacion> findByVendedorId(Long vendedorId) {
        return repository.findByVendedor_Id(vendedorId)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<Notificacion> findByVendedorIdAndLeidoFalse(Long vendedorId, boolean leido) {
        return repository.findByVendedor_IdAndLeidoFalse(vendedorId)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<Notificacion> findByVendedorIdAndLeidoTrue(Long vendedorId, boolean leido) {
        return repository.findByVendedor_IdAndLeidoTrue(vendedorId)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<Notificacion> findByVendedorIdAndTipo(Long vendedorId, com.gestionart.api.domain.enums.TipoNotificacion tipo) {
        return repository.findByVendedor_IdAndTipo(vendedorId, tipo)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    private Notificacion toDomain(NotificacionEntity e) {
        return new Notificacion(
                e.getId(),
                e.getVendedor() != null ? e.getVendedor().getId() : null,
                e.getTipo(),
                e.isLeido(),
                e.getFecha()
        );
    }

    private NotificacionEntity toEntity(Notificacion d) {
        NotificacionEntity e = new NotificacionEntity();
        e.setId(d.getId());
        e.setTipo(d.getTipo());
        e.setLeido(d.isLeido());
        e.setFecha(d.getFecha());

        if (d.getVendedorId() != null) {
            VendedorEntity v = new VendedorEntity();
            v.setId(d.getVendedorId());
            e.setVendedor(v);
        }

        return e;
    }

    @Override
    public Optional<Notificacion> findById(Long id) {
        return repository.findById(id)
                .map(this::toDomain);
    }
}