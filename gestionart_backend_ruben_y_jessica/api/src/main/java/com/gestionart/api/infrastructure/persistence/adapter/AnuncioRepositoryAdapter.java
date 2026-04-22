package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.enums.Categoria;
import com.gestionart.api.domain.models.Anuncio;
import com.gestionart.api.domain.repository.AnuncioRepository;
import com.gestionart.api.infrastructure.persistence.entity.AnuncioEntity;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import com.gestionart.api.infrastructure.persistence.repository.AnuncioJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class AnuncioRepositoryAdapter implements AnuncioRepository {

    private final AnuncioJpaRepository repository;

    public AnuncioRepositoryAdapter(AnuncioJpaRepository repository) {
        this.repository = repository;
    }

    public Anuncio save(Anuncio a) {
        return toDomain(repository.save(toEntity(a)));
    }

    public Optional<Anuncio> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public List<Anuncio> findAll() {
        return repository.findAll().stream().map(this::toDomain).collect(Collectors.toList());
    }

    public List<Anuncio> findByIdVendedor(Long id) {
        return repository.findByVendedor_Id(id).stream().map(this::toDomain).collect(Collectors.toList());
    }

    public List<Anuncio> findByCategoria(Categoria categoria) {
        return repository.findByCategoria(categoria).stream().map(this::toDomain).collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    private Anuncio toDomain(AnuncioEntity e) {
        return new Anuncio(e.getTitulo(), e.getCategoria(), e.getPrecio(),
                e.getImagen(), e.getFechaInicio(), e.getFechaFin(), e.isActivo(),
                e.getVendedor() != null ? e.getVendedor().getId() : null);
    }

    private AnuncioEntity toEntity(Anuncio d) {
        AnuncioEntity e = new AnuncioEntity();
        e.setId(d.getId());
        e.setTitulo(d.getTitulo());
        e.setCategoria(d.getCategoria());
        e.setPrecio(d.getPrecio());
        e.setImagen(d.getImagen());
        e.setFechaInicio(d.getFechaInicio());
        e.setFechaFin(d.getFechaFin());
        e.setActivo(d.isActivo());

        if (d.getIdVendedor() != null) {
            VendedorEntity v = new VendedorEntity();
            v.setId(d.getIdVendedor());
            e.setVendedor(v);
        }
        return e;
    }
}
