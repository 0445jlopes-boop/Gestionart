package com.gestionart.api.domain.models;

import java.time.LocalDateTime;
import java.util.List;

import com.gestionart.api.domain.enums.EstadoPedido;

public class Pedido {
    private Long id;
    private Long idComprador;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaConfirmacion;
    private EstadoPedido estado;
    private List<LineaPedido> lineas;

    public Pedido() {
    }

    public Pedido(Long id,Long idComprador,LocalDateTime fechaCreacion,LocalDateTime fechaConfirmacion,EstadoPedido estado,List<LineaPedido> lineas) {
        this.id = id;
        this.idComprador = idComprador;
        this.fechaCreacion = fechaCreacion;
        this.fechaConfirmacion = fechaConfirmacion;
        this.estado = estado;
        this.lineas = lineas;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getIdComprador() {
        return idComprador;
    }

    public void setIdComprador(Long idComprador) {
        this.idComprador = idComprador;
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

    public List<LineaPedido> getLineas() {
        return lineas;
    }

    public void setLineas(List<LineaPedido> lineas) {
        this.lineas = lineas;
    }
    
}
