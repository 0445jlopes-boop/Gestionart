package com.gestionart.api.infrastructure.persistence.entity;

import com.gestionart.api.domain.enums.EstadoSolicitud;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "solicitudes_exclusivas")
public class SolicitudExclusivaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private CompradorEntity comprador;

    @ManyToOne
    private ArticuloEntity articulo;

    @ManyToOne
    private VendedorEntity vendedor;

    private String mensaje;

    @Enumerated(EnumType.STRING)
    private EstadoSolicitud estado;

    private LocalDateTime fecha;

    public SolicitudExclusivaEntity() {}

    public SolicitudExclusivaEntity(Long id, CompradorEntity comprador, ArticuloEntity articulo,
            VendedorEntity vendedor, String mensaje, EstadoSolicitud estado, LocalDateTime fecha) {
        this.id = id;
        this.comprador = comprador;
        this.articulo = articulo;
        this.vendedor = vendedor;
        this.mensaje = mensaje;
        this.estado = estado;
        this.fecha = fecha;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public CompradorEntity getComprador() {
        return comprador;
    }

    public void setComprador(CompradorEntity comprador) {
        this.comprador = comprador;
    }

    public ArticuloEntity getArticulo() {
        return articulo;
    }

    public void setArticulo(ArticuloEntity articulo) {
        this.articulo = articulo;
    }

    public VendedorEntity getVendedor() {
        return vendedor;
    }

    public void setVendedor(VendedorEntity vendedor) {
        this.vendedor = vendedor;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public EstadoSolicitud getEstado() {
        return estado;
    }

    public void setEstado(EstadoSolicitud estado) {
        this.estado = estado;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }
    
}
