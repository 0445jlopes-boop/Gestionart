package com.gestionart.api.infrastructure.persistence.entity;

import com.gestionart.api.domain.enums.Categoria;
import jakarta.persistence.*;

@Entity
@Table(name = "articulos")
public class ArticuloEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String titulo;

    @Enumerated(EnumType.STRING)
    private Categoria categoria;

    private double precio;
    private String imagen;
    private String descripcion;
    private int stock;

    @ManyToOne
    @JoinColumn(name = "vendedor_id")
    private VendedorEntity vendedor;

    public ArticuloEntity() {}

    public ArticuloEntity(Long id, String titulo, Categoria categoria, double precio, String imagen, String descripcion,
            int stock, VendedorEntity vendedor) {
        this.id = id;
        this.titulo = titulo;
        this.categoria = categoria;
        this.precio = precio;
        this.imagen = imagen;
        this.descripcion = descripcion;
        this.stock = stock;
        this.vendedor = vendedor;
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

    public VendedorEntity getVendedor() {
        return vendedor;
    }

    public void setVendedor(VendedorEntity vendedor) {
        this.vendedor = vendedor;
    }
    
}
