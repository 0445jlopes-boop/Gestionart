package com.gestionart.api.domain.models;

import java.time.LocalDateTime;
import java.util.List;

public class Pedido {
    private long id;
    private LocalDateTime fecha; 
    private String estado;
    private int idComprador;
    private int idVendedor;
    private List<LineaPedido> lineas;
    
    public Pedido() {
    }

    public Pedido(long id, LocalDateTime fecha, String estado, int idComprador, int idVendedor,
            List<LineaPedido> lineas) {
        this.id = id;
        this.fecha = fecha;
        this.estado = estado;
        this.idComprador = idComprador;
        this.idVendedor = idVendedor;
        this.lineas = lineas;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public int getIdComprador() {
        return idComprador;
    }

    public void setIdComprador(int idComprador) {
        this.idComprador = idComprador;
    }

    public int getIdVendedor() {
        return idVendedor;
    }

    public void setIdVendedor(int idVendedor) {
        this.idVendedor = idVendedor;
    }

    public List<LineaPedido> getLineas() {
        return lineas;
    }

    public void setLineas(List<LineaPedido> lineas) {
        this.lineas = lineas;
    }
    
}
