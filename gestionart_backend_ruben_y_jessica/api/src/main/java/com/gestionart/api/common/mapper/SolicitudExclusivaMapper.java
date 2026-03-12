package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.SolicitudExclusiva;
import com.gestionart.api.infrastructure.persistence.entity.ArticuloEntity;
import com.gestionart.api.infrastructure.persistence.entity.CompradorEntity;
import com.gestionart.api.infrastructure.persistence.entity.SolicitudExclusivaEntity;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;

@Component
public class SolicitudExclusivaMapper {

    public SolicitudExclusivaEntity toEntity(SolicitudExclusiva solicitud) {

        SolicitudExclusivaEntity entity = new SolicitudExclusivaEntity();

        entity.setId(solicitud.getId());
        entity.setMensaje(solicitud.getMensaje());
        entity.setEstado(solicitud.getEstado());
        entity.setFecha(solicitud.getFecha());

        CompradorEntity comprador = new CompradorEntity();
        comprador.setId(solicitud.getIdComprador());

        ArticuloEntity articulo = new ArticuloEntity();
        articulo.setId(solicitud.getIdArticulo());

        VendedorEntity vendedor = new VendedorEntity();
        vendedor.setId(solicitud.getIdVendedor());

        entity.setComprador(comprador);
        entity.setArticulo(articulo);
        entity.setVendedor(vendedor);

        return entity;
    }

    public SolicitudExclusiva toDomain(SolicitudExclusivaEntity entity) {

        return new SolicitudExclusiva(
            entity.getId(),
            entity.getComprador().getId(),
            entity.getArticulo().getId(),
            entity.getVendedor().getId(),
            entity.getMensaje(),
            entity.getEstado(),
            entity.getFecha()
        );
    }
}
