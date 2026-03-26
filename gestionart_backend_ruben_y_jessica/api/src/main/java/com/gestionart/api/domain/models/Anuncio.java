package com.gestionart.api.domain.models;

import java.time.LocalDateTime;

import com.gestionart.api.domain.enums.Categoria;

public class Anuncio {
    private Long id;
    private String titulo;
    private Categoria categoria;
    private double precio;
    private String imagen;
    private LocalDateTime fechaInicio;
    private LocalDateTime fechaFin;
    private Long idVendedor;
    private boolean activo;
    


    public Anuncio(Long id, String titulo, Categoria categoria, double precio, String imagen, LocalDateTime fechaInicio,
            LocalDateTime fechaFin, boolean activo, Long idVendedor) {
        this.id = id;
        this.titulo = titulo;
        this.categoria = categoria;
        this.precio = precio;
        this.imagen = imagen;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.idVendedor = idVendedor;
        this.activo = activo;
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

    

    public Long getIdVendedor() {
        return idVendedor;
    }

    public void setIdVendedor(Long idVendedor) {
        this.idVendedor = idVendedor;
    }

    public LocalDateTime getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(LocalDateTime fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public LocalDateTime getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(LocalDateTime fechaFin) {
        this.fechaFin = fechaFin;
    }



    public boolean isActivo() {
        return activo;
    }



    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    

}
