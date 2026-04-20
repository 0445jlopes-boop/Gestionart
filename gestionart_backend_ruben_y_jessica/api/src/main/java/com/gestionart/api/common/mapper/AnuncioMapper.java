package com.gestionart.api.common.mapper;

import org.springframework.stereotype.Component;

import com.gestionart.api.domain.models.Anuncio;
import com.gestionart.api.infrastructure.persistence.entity.AnuncioEntity;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import com.gestionart.api.presentation.dto.request.AnuncioRequest;
import com.gestionart.api.presentation.dto.response.AnuncioResponse;

@Component
public class AnuncioMapper {

    public Anuncio toDomain(AnuncioRequest request) {
        return new Anuncio(
            null,
            request.titulo(),
            request.categoria(),
            request.precio(),
            request.imagen(),
            null, 
            null, 
            false, 
            request.idVendedor()
        );
    }

    public AnuncioEntity toEntity(Anuncio anuncio) {
        AnuncioEntity entity = new AnuncioEntity();
        entity.setId(anuncio.getId());
        entity.setTitulo(anuncio.getTitulo());
        entity.setCategoria(anuncio.getCategoria());
        entity.setPrecio(anuncio.getPrecio());
        entity.setImagen(anuncio.getImagen());
        entity.setFechaInicio(anuncio.getFechaInicio());
        entity.setFechaFin(anuncio.getFechaFin());
        entity.setActivo(anuncio.isActivo());

        VendedorEntity vendedor = new VendedorEntity();
        vendedor.setId(anuncio.getIdVendedor());
        entity.setVendedor(vendedor);

        return entity;
    }

    public Anuncio toDomain(AnuncioEntity entity) {
        return new Anuncio(
            entity.getId(),
            entity.getTitulo(),
            entity.getCategoria(),
            entity.getPrecio(),
            entity.getImagen(),
            entity.getFechaInicio(),
            entity.getFechaFin(),
            entity.isActivo(),
            entity.getVendedor().getId()
        );
    }

    public AnuncioResponse toResponse(Anuncio anuncio) {
        return new AnuncioResponse(
            anuncio.getId(),
            anuncio.getTitulo(),
            anuncio.getCategoria(),
            anuncio.getPrecio(),
            anuncio.getImagen(),
            anuncio.getFechaInicio(),
            anuncio.getFechaFin(),
            anuncio.getIdVendedor(),
            anuncio.isActivo()
        );
    }
}