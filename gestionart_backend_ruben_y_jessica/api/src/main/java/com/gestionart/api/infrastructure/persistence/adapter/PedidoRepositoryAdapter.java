package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.Pedido;
import com.gestionart.api.domain.repository.PedidoRepository;
import com.gestionart.api.infrastructure.persistence.entity.PedidoEntity;
import com.gestionart.api.infrastructure.persistence.entity.CompradorEntity;
import com.gestionart.api.infrastructure.persistence.repository.PedidoJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class PedidoRepositoryAdapter implements PedidoRepository {

    private final PedidoJpaRepository repository;

    public PedidoRepositoryAdapter(PedidoJpaRepository repository) {
        this.repository = repository;
    }

    public Pedido save(Pedido p) {
        return toDomain(repository.save(toEntity(p)));
    }

    public Optional<Pedido> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public Optional<Pedido> findByIdCompradorAndEstado(Long idComprador, com.gestionart.api.domain.enums.EstadoPedido estado) {
        return repository.findByComprador_IdAndEstado(idComprador, estado)
                .map(this::toDomain);
    }

    public List<Pedido> findByIdComprador(Long idComprador) {
        return repository.findByComprador_Id(idComprador)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<Pedido> findByEstado(com.gestionart.api.domain.enums.EstadoPedido estado) {
        return repository.findByEstado(estado)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    private Pedido toDomain(PedidoEntity e) {
        return new Pedido(
                e.getId(),
                e.getComprador() != null ? e.getComprador().getId() : null,
                e.getFechaCreacion(),
                e.getFechaConfirmacion(),
                e.getEstado(), 
                null
        );
    }

    private PedidoEntity toEntity(Pedido d) {
        PedidoEntity e = new PedidoEntity();
        e.setId(d.getId());
        e.setFechaCreacion(d.getFechaCreacion());
        e.setFechaConfirmacion(d.getFechaConfirmacion());
        e.setEstado(d.getEstado());

        if (d.getIdComprador() != null) {
            CompradorEntity c = new CompradorEntity();
            c.setId(d.getIdComprador());
            e.setComprador(c);
        }

        return e;
    }
}
