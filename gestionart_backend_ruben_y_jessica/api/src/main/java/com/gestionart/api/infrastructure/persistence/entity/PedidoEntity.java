package com.gestionart.api.infrastructure.persistence.entity;

import com.gestionart.api.domain.enums.EstadoPedido;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "pedidos")
public class PedidoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "comprador_id")
    private CompradorEntity comprador;

    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaConfirmacion;

    @Enumerated(EnumType.STRING)
    private EstadoPedido estado;

    @OneToMany(mappedBy = "pedido", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LineaPedidoEntity> lineas;

    public PedidoEntity() {}

    public PedidoEntity(Long id, CompradorEntity comprador, LocalDateTime fechaCreacion,
            LocalDateTime fechaConfirmacion, EstadoPedido estado) {
        this.id = id;
        this.comprador = comprador;
        this.fechaCreacion = fechaCreacion;
        this.fechaConfirmacion = fechaConfirmacion;
        this.estado = estado;
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

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public LocalDateTime getFechaConfirmacion() {
        return fechaConfirmacion;
    }

    public void setFechaConfirmacion(LocalDateTime fechaConfirmacion) {
        this.fechaConfirmacion = fechaConfirmacion;
    }

    public EstadoPedido getEstado() {
        return estado;
    }

    public void setEstado(EstadoPedido estado) {
        this.estado = estado;
    }
    
}

