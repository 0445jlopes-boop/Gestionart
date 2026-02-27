package com.gestionart.api.domain.models;

import com.gestionart.api.domain.enums.Categoria;

public class Articulo {
    private Long id;
    private String titulo;
    private Categoria categoria;
    private double precio;
    private String imagen;
    private String descripcion;
    private int stock;
    private Long idVendedor;
    
    public Articulo() {
    }

    public Articulo(Long id, String titulo, Categoria categoria, double precio, String imagen, String descripcion, int stock, Long idVendedor) {
        this.id = id;
        this.titulo = titulo;
        this.categoria = categoria;
        this.precio = precio;
        this.imagen = imagen;
        this.descripcion = descripcion;
        this.stock = stock;
        this.idVendedor = idVendedor;
    }

    public Long getId() {
        return id;
    }
    public void setId(Long id) {
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
    public String getDescripcion() {
        return descripcion;
    }
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public Long getIdVendedor() {
        return idVendedor;
    }

    public void setIdVendedor(Long idVendedor) {
        this.idVendedor = idVendedor;
    }

    
}
