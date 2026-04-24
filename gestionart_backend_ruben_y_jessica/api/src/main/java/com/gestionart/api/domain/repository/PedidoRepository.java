package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.enums.EstadoPedido;
import com.gestionart.api.domain.models.Pedido;

public interface PedidoRepository {
    Pedido save(Pedido pedido);
    Optional<Pedido> findById(Long id);
    List<Pedido> findByIdCompradorAndEstado(Long idComprador, EstadoPedido estado);
    List<Pedido> findByIdComprador(Long idComprador);
    List<Pedido> findByEstado(EstadoPedido estado);
    void deleteById(Long id);
}
