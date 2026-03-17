package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.domain.repository.LineaPedidoRepository;
import com.gestionart.api.infrastructure.persistence.entity.LineaPedidoEntity;
import com.gestionart.api.infrastructure.persistence.entity.PedidoEntity;
import com.gestionart.api.infrastructure.persistence.entity.ArticuloEntity;
import com.gestionart.api.infrastructure.persistence.repository.LineaPedidoJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class LineaPedidoRepositoryAdapter implements LineaPedidoRepository {

    private final LineaPedidoJpaRepository repository;

    public LineaPedidoRepositoryAdapter(LineaPedidoJpaRepository repository) {
        this.repository = repository;
    }

    public LineaPedido save(LineaPedido l) {
        return toDomain(repository.save(toEntity(l)));
    }

    public Optional<LineaPedido> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public List<LineaPedido> findByIdPedido(Long idPedido) {
        return repository.findByPedido_Id(idPedido)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public void deleteByIdPedido(Long idPedido) {
        repository.deleteByPedido_Id(idPedido);
    }

    private LineaPedido toDomain(LineaPedidoEntity e) {
        return new LineaPedido(
                e.getId(),
                e.getPedido() != null ? e.getPedido().getId() : null,
                e.getArticulo() != null ? e.getArticulo().getId() : null,
                e.getCantidad(),
                e.getPrecioUnitario()
        );
    }

    private LineaPedidoEntity toEntity(LineaPedido d) {
        LineaPedidoEntity e = new LineaPedidoEntity();
        e.setId(d.getId());
        e.setCantidad(d.getCantidad());
        e.setPrecioUnitario(d.getPrecioUnitario());

        if (d.getIdPedido() != null) {
            PedidoEntity p = new PedidoEntity();
            p.setId(d.getIdPedido());
            e.setPedido(p);
        }

        if (d.getIdArticulo() != null) {
            ArticuloEntity a = new ArticuloEntity();
            a.setId(d.getIdArticulo());
            e.setArticulo(a);
        }

        return e;
    }
}
