package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.PedidoEntity;
import com.gestionart.api.domain.enums.EstadoPedido;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PedidoJpaRepository extends JpaRepository<PedidoEntity, Long> {

    Optional<PedidoEntity> findByComprador_IdAndEstado(Long idComprador, EstadoPedido estado);

    List<PedidoEntity> findByComprador_Id(Long idComprador);

    List<PedidoEntity> findByEstado(EstadoPedido estado);
}
