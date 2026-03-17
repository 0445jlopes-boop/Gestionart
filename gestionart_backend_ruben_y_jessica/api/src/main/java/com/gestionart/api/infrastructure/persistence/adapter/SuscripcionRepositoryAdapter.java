package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.Suscripcion;
import com.gestionart.api.domain.repository.SuscripcionRepository;
import com.gestionart.api.infrastructure.persistence.entity.SuscripcionEntity;
import com.gestionart.api.infrastructure.persistence.entity.CompradorEntity;
import com.gestionart.api.infrastructure.persistence.repository.SuscripcionJpaRepository;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class SuscripcionRepositoryAdapter implements SuscripcionRepository {

    private final SuscripcionJpaRepository repository;

    public SuscripcionRepositoryAdapter(SuscripcionJpaRepository repository) {
        this.repository = repository;
    }

    public Suscripcion save(Suscripcion s) {
        return toDomain(repository.save(toEntity(s)));
    }

    public Optional<Suscripcion> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public Optional<Suscripcion> findByIdComprador(Long idComprador) {
        return repository.findByComprador_Id(idComprador)
                .map(this::toDomain);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    private Suscripcion toDomain(SuscripcionEntity e) {
        return new Suscripcion(
                e.getId(),
                e.getComprador() != null ? e.getComprador().getId() : null,
                e.getFechaInicio(),
                e.getFechaFin(),
                e.isActiva()
        );
    }

    private SuscripcionEntity toEntity(Suscripcion d) {
        SuscripcionEntity e = new SuscripcionEntity();
        e.setId(d.getId());
        e.setFechaInicio(d.getFechaInicio());
        e.setFechaFin(d.getFechaFin());
        e.setActiva(d.isActiva());

        if (d.getIdComprador() != null) {
            CompradorEntity c = new CompradorEntity();
            c.setId(d.getIdComprador());
            e.setComprador(c);
        }

        return e;
    }
}