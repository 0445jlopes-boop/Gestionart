package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.LineaPedidoEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LineaPedidoJpaRepository extends JpaRepository<LineaPedidoEntity, Long> {

    List<LineaPedidoEntity> findByPedido_Id(Long idPedido);

    void deleteByPedido_Id(Long idPedido);
}
