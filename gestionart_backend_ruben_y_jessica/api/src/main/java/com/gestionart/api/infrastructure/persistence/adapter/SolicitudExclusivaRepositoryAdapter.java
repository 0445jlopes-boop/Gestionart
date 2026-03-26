package com.gestionart.api.infrastructure.persistence.adapter;

import com.gestionart.api.domain.models.SolicitudExclusiva;
import com.gestionart.api.domain.repository.SolicitudExclusivaRepository;
import com.gestionart.api.infrastructure.persistence.entity.SolicitudExclusivaEntity;
import com.gestionart.api.infrastructure.persistence.entity.CompradorEntity;
import com.gestionart.api.infrastructure.persistence.entity.VendedorEntity;
import com.gestionart.api.infrastructure.persistence.entity.ArticuloEntity;
import com.gestionart.api.infrastructure.persistence.repository.SolicitudExclusivaJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class SolicitudExclusivaRepositoryAdapter implements SolicitudExclusivaRepository {

    private final SolicitudExclusivaJpaRepository repository;

    public SolicitudExclusivaRepositoryAdapter(SolicitudExclusivaJpaRepository repository) {
        this.repository = repository;
    }

    public SolicitudExclusiva save(SolicitudExclusiva s) {
        return toDomain(repository.save(toEntity(s)));
    }

    public Optional<SolicitudExclusiva> findById(Long id) {
        return repository.findById(id).map(this::toDomain);
    }

    public List<SolicitudExclusiva> findByIdComprador(Long idComprador) {
        return repository.findByComprador_Id(idComprador)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<SolicitudExclusiva> findByIdVendedor(Long idVendedor) {
        return repository.findByVendedor_Id(idVendedor)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<SolicitudExclusiva> findByIdVendedorAndEstado(Long idVendedor, com.gestionart.api.domain.enums.EstadoSolicitud estado) {
        return repository.findByVendedor_IdAndEstado(idVendedor, estado)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<SolicitudExclusiva> findByIdCompradorAndEstado(Long idComprador, com.gestionart.api.domain.enums.EstadoSolicitud estado) {
        return repository.findByComprador_IdAndEstado(idComprador, estado)
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public List<SolicitudExclusiva> findAll() {
        return repository.findAll()
                .stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    private SolicitudExclusiva toDomain(SolicitudExclusivaEntity e) {
        return new SolicitudExclusiva(
                e.getId(),
                e.getComprador() != null ? e.getComprador().getId() : null,
                e.getArticulo() != null ? e.getArticulo().getId() : null,
                e.getVendedor() != null ? e.getVendedor().getId() : null,
                e.getMensaje(),
                e.getEstado(),
                e.getFecha()
        );
    }

    private SolicitudExclusivaEntity toEntity(SolicitudExclusiva d) {
        SolicitudExclusivaEntity e = new SolicitudExclusivaEntity();
        e.setId(d.getId());
        e.setMensaje(d.getMensaje());
        e.setEstado(d.getEstado());
        e.setFecha(d.getFecha());

        if (d.getIdComprador() != null) {
            CompradorEntity c = new CompradorEntity();
            c.setId(d.getIdComprador());
            e.setComprador(c);
        }

        if (d.getIdArticulo() != null) {
            ArticuloEntity a = new ArticuloEntity();
            a.setId(d.getIdArticulo());
            e.setArticulo(a);
        }

        if (d.getIdVendedor() != null) {
            VendedorEntity v = new VendedorEntity();
            v.setId(d.getIdVendedor());
            e.setVendedor(v);
        }

        return e;
    }
}
