package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.models.LineaPedido;

public interface LineaPedidoRepository {
    LineaPedido save(LineaPedido lineaPedido);
    Optional<LineaPedido> findById(Long id);
    List<LineaPedido> findByIdPedido(Long idPedido);
    Optional<LineaPedido> findByIdPedidoAndIdArticulo(Long idPedido, Long idArticulo);
    void deleteById(Long id);
    void deleteByIdPedido(Long idPedido);
}
