package com.gestionart.api.common.mapper;

package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.infrastructure.persistence.entity.ArticuloEntity;
import com.gestionart.api.infrastructure.persistence.entity.LineaPedidoEntity;
import com.gestionart.api.infrastructure.persistence.entity.PedidoEntity;

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

    public LineaPedido toDomain(LineaPedidoEntity entity) {

        return new LineaPedido(
            entity.getId(),
            entity.getPedido().getId(),
            entity.getArticulo().getId(),
            entity.getCantidad(),
            entity.getPrecioUnitario()
        );
    }
}
