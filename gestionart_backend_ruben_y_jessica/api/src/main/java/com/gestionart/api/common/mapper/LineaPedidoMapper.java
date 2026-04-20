package com.gestionart.api.common.mapper;

import org.jspecify.annotations.Nullable;
import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.infrastructure.persistence.entity.ArticuloEntity;
import com.gestionart.api.infrastructure.persistence.entity.LineaPedidoEntity;
import com.gestionart.api.infrastructure.persistence.entity.PedidoEntity;
import com.gestionart.api.presentation.dto.request.LineaPedidoRequest;
import com.gestionart.api.presentation.dto.response.LineaPedidoResponse;

@Component
public class LineaPedidoMapper {

    public LineaPedidoEntity toEntity(LineaPedido linea) {

        LineaPedidoEntity entity = new LineaPedidoEntity();

        entity.setId(linea.getId());
        entity.setCantidad(linea.getCantidad());
        entity.setPrecioUnitario(linea.getPrecioUnitario());

        PedidoEntity pedido = new PedidoEntity();
        pedido.setId(linea.getIdPedido());

        ArticuloEntity articulo = new ArticuloEntity();
        articulo.setId(linea.getIdArticulo());

        entity.setPedido(pedido);
        entity.setArticulo(articulo);

        return entity;
    }

    public LineaPedido toDomain(LineaPedidoRequest request) {

        return new LineaPedido(
            null,
            request.idPedido(),
            request.idArticulo(),
            request.cantidad(),
            request.precioUnitario()
        );
    }

    public LineaPedidoResponse toResponse(LineaPedido lineaPedido) 
    {
        return new LineaPedidoResponse(
            lineaPedido.getId(),
            lineaPedido.getIdArticulo(),
            lineaPedido.getCantidad(),
            lineaPedido.getPrecioUnitario()
        );
       
    }
}
