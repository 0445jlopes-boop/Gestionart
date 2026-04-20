package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.models.LineaPedido;

public interface LineaPedidoRepository {
    LineaPedido save(LineaPedido lineaPedido);
    Optional<LineaPedido> findById(Long id);
    Optional<LineaPedido> findByIdPedido(Long idPedido);
    List<LineaPedido> findAllByPedidoId(Long idPedido);
    void deleteById(Long id);
}
