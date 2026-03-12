package com.gestionart.api.common.mapper;

package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.Articulo;
import com.gestionart.api.infrastructure.persistence.entity.ArticuloEntity;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import com.gestionart.api.presentation.dto.request.ArticuloRequest;
import com.gestionart.api.presentation.dto.response.ArticuloResponse;

@Component
public class ArticuloMapper {

    public Articulo toDomain(ArticuloRequest request) {
        return new Articulo(
            null,
            request.titulo(),
            request.categoria(),
            request.precio(),
            request.imagen(),
            request.descripcion(),
            request.stock(),
            request.idVendedor()
        );
    }

    public ArticuloEntity toEntity(Articulo articulo) {

        ArticuloEntity entity = new ArticuloEntity();

        entity.setId(articulo.getId());
        entity.setTitulo(articulo.getTitulo());
        entity.setCategoria(articulo.getCategoria());
        entity.setPrecio(articulo.getPrecio());
        entity.setImagen(articulo.getImagen());
        entity.setDescripcion(articulo.getDescripcion());
        entity.setStock(articulo.getStock());

        VendedorEntity vendedor = new VendedorEntity();
        vendedor.setId(articulo.getIdVendedor());

        entity.setVendedor(vendedor);

        return entity;
    }

    public Articulo toDomain(ArticuloEntity entity) {
        return new Articulo(
            entity.getId(),
            entity.getTitulo(),
            entity.getCategoria(),
            entity.getPrecio(),
            entity.getImagen(),
            entity.getDescripcion(),
            entity.getStock(),
            entity.getVendedor().getId()
        );
    }

    public ArticuloResponse toResponse(Articulo articulo) {
        return new ArticuloResponse(
            articulo.getId(),
            articulo.getTitulo(),
            articulo.getCategoria(),
            articulo.getPrecio(),
            articulo.getImagen(),
            articulo.getDescripcion(),
            articulo.getStock(),
            articulo.getIdVendedor()
        );
    }
}
