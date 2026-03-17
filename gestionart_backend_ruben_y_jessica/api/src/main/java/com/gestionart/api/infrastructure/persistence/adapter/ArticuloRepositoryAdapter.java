package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.Articulo;
import com.gestionart.api.domain.repository.ArticuloRepository;
import com.gestionart.api.infrastructure.persistence.entity.ArticuloEntity;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import com.gestionart.api.infrastructure.persistence.repository.ArticuloJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class ArticuloRepositoryAdapter implements ArticuloRepository {

    private final ArticuloJpaRepository repository;

    public ArticuloRepositoryAdapter(ArticuloJpaRepository repository) {
        this.repository = repository;
    }

    public Articulo save(Articulo a) {
        return toDomain(repository.save(toEntity(a)));
    }

    public Optional<Articulo> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public List<Articulo> findAll() {
        return repository.findAll().stream().map(this::toDomain).collect(Collectors.toList());
    }

    public List<Articulo> findByStockGreatherThan(int stock) {
        return repository.findByStockGreaterThan(stock).stream().map(this::toDomain).collect(Collectors.toList());
    }

    public List<Articulo> findByIdVendedor(Long id) {
        return repository.findByVendedor_Id(id).stream().map(this::toDomain).collect(Collectors.toList());
    }

    public List<Articulo> findByCategoria(String categoria) {
        return repository.findByCategoria(
                com.gestionart.api.domain.enums.Categoria.valueOf(categoria)
        ).stream().map(this::toDomain).collect(Collectors.toList());
    }

    public List<Articulo> findByIdVendedorAndCategoria(Long id, String categoria) {
        return repository.findByVendedor_IdAndCategoria(
                id,
                com.gestionart.api.domain.enums.Categoria.valueOf(categoria)
        ).stream().map(this::toDomain).collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    private Articulo toDomain(ArticuloEntity e) {
        return new Articulo(e.getId(), e.getTitulo(), e.getCategoria(), e.getPrecio(),
                e.getImagen(), e.getDescripcion(), e.getStock(),
                e.getVendedor() != null ? e.getVendedor().getId() : null);
    }

    private ArticuloEntity toEntity(Articulo d) {
        ArticuloEntity e = new ArticuloEntity();
        e.setId(d.getId());
        e.setTitulo(d.getTitulo());
        e.setCategoria(d.getCategoria());
        e.setPrecio(d.getPrecio());
        e.setImagen(d.getImagen());
        e.setDescripcion(d.getDescripcion());
        e.setStock(d.getStock());

        if (d.getIdVendedor() != null) {
            VendedorEntity v = new VendedorEntity();
            v.setId(d.getIdVendedor());
            e.setVendedor(v);
        }
        return e;
    }
}
