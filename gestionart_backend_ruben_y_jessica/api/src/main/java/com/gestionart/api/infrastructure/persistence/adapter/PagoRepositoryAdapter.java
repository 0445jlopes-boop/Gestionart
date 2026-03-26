package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.Pago;
import com.gestionart.api.domain.repository.PagoRepository;
import com.gestionart.api.infrastructure.persistence.entity.PagoEntity;
import com.gestionart.api.infrastructure.persistence.repository.PagoJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class PagoRepositoryAdapter implements PagoRepository {

    private final PagoJpaRepository repository;

    public PagoRepositoryAdapter(PagoJpaRepository repository) {
        this.repository = repository;
    }

    public Pago save(Pago p) {
        return toDomain(repository.save(toEntity(p)));
    }

    public Optional<Pago> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public List<Pago> findByTipoPago(com.gestionart.api.domain.enums.TipoPago tipoPago) {
        return repository.findByTipoPago(tipoPago)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<Pago> findByReferenciaId(Long referenciaId) {
        return repository.findByReferenciaId(referenciaId)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public Optional<Pago> findByReferenciaExterna(String referenciaExterna) {
        return repository.findByReferenciaExterna(referenciaExterna)
                .map(this::toDomain);
    }

    public List<Pago> findByEstado(com.gestionart.api.domain.enums.EstadoPago estado) {
        return repository.findByEstado(estado)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<Pago> findAll() {
        return repository.findAll()
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    private Pago toDomain(PagoEntity e) {
        return new Pago(
                e.getId(),
                e.getTipoPago(),
                e.getReferenciaId(),
                e.getImporte(),
                e.getEstado(),
                e.getReferenciaExterna(),
                e.getFecha()
        );
    }

    private PagoEntity toEntity(Pago d) {
        PagoEntity e = new PagoEntity();
        e.setId(d.getId());
        e.setTipoPago(d.getTipoPago());
        e.setReferenciaId(d.getReferenciaId());
        e.setImporte(d.getImporte());
        e.setEstado(d.getEstado());
        e.setReferenciaExterna(d.getReferenciaExterna());
        e.setFecha(d.getFecha());
        return e;
    }
}