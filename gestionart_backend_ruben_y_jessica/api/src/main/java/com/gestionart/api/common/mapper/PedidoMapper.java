package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.Pedido;
import com.gestionart.api.infrastructure.persistence.entity.CompradorEntity;
import com.gestionart.api.infrastructure.persistence.entity.PedidoEntity;
import com.gestionart.api.presentation.dto.response.PedidoResponse;

@Component
public class PedidoMapper {

    private final LineaPedidoMapper lineaMapper;

    public PedidoMapper(LineaPedidoMapper lineaMapper) {
        this.lineaMapper = lineaMapper;
    }

    public PedidoEntity toEntity(Pedido pedido) {

        PedidoEntity entity = new PedidoEntity();

        entity.setId(pedido.getId());
        entity.setFechaCreacion(pedido.getFechaCreacion());
        entity.setFechaConfirmacion(pedido.getFechaConfirmacion());
        entity.setEstado(pedido.getEstado());

        CompradorEntity comprador = new CompradorEntity();
        comprador.setId(pedido.getIdComprador());

        entity.setComprador(comprador);

        return entity;
    }

    public Pedido toDomain(PedidoEntity entity) {

        return new Pedido(
            entity.getId(),
            entity.getComprador().getId(),
            entity.getFechaCreacion(),
            entity.getFechaConfirmacion(),
            entity.getEstado(),
            null
        );
    }
     public PedidoResponse toResponse(Pedido pedido) {

        return new PedidoResponse(
                pedido.getId(),
                pedido.getIdComprador(),
                pedido.getFechaCreacion(),
                pedido.getFechaConfirmacion(),
                pedido.getEstado(),
                pedido.getLineas()
        );
    }
}
