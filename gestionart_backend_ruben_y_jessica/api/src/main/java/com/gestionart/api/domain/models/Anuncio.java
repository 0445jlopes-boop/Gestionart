package com.gestionart.api.domain.models;

public class Anuncio {
    private long id;
    private String titulo;
    private Categoria categoria;
    private double precio;
    private String imagen;
    private int tiempo;
    private long idVendedor;
    
    public Anuncio() {
    }

    public Anuncio(long id, String titulo, Categoria categoria, double precio, String imagen, int tiempo, long idVendedor) {
        this.id = id;
        this.titulo = titulo;
        this.categoria = categoria;
        this.precio = precio;
        this.imagen = imagen;
        this.tiempo = tiempo;
        this.idVendedor = idVendedor;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public Categoria getCategoria() {
        return categoria;
    }

    public void setCategoria(Categoria categoria) {
        this.categoria = categoria;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public int getTiempo() {
        return tiempo;
    }

    public void setTiempo(int tiempo) {
        this.tiempo = tiempo;
    }

    public long getIdVendedor() {
        return idVendedor;
    }

    public void setIdVendedor(long idVendedor) {
        this.idVendedor = idVendedor;
    }

}
