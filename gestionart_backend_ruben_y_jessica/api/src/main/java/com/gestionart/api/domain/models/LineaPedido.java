package com.gestionart.api.domain.models;

public class LineaPedido {
    private long id;
    private long idPedido;
    private long idArticulo;
    private int cantidad;
    private double precioUnitario;
   
    public LineaPedido() {
    }

    public LineaPedido(long id,long idPedido, long idArticulo, int cantidad, double precioUnitario) {
        this.id = id;
        this.idPedido = idPedido;
        this.idArticulo = idArticulo;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getIdArticulo() {
        return idArticulo;
    }

    public void setIdArticulo(long idArticulo) {
        this.idArticulo = idArticulo;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    public long getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(long idPedido) {
        this.idPedido = idPedido;
    }

}
