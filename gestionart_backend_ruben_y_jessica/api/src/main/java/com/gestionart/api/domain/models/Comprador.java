package com.gestionart.api.domain.models;

import java.time.LocalDateTime;

public class Comprador {
    private Long id; 
    private String correoElectronico;
    private String nombre;
    private String imagen;
    private String contrasena;
    private String direccion;
    private TipoCuentaComprador tipoCuenta;
    private LocalDateTime fechaInicioPremium;

    public Comprador() {
    }

    

    public Comprador(Long id, String correoElectronico, String nombre, String imagen, String contrasena,
            String direccion, TipoCuentaComprador tipoCuenta, LocalDateTime fechaInicioPremium) {
        this.id = id;
        this.correoElectronico = correoElectronico;
        this.nombre = nombre;
        this.imagen = imagen;
        this.contrasena = contrasena;
        this.direccion = direccion;
        this.tipoCuenta = tipoCuenta;
        this.fechaInicioPremium = fechaInicioPremium;
    }



    public Long getId() {
        return id;
    }

    public String getCorreoElectronico() {
        return correoElectronico;
    }

    public void setCorreoElectronico(String correoElectronico) {
        this.correoElectronico = correoElectronico;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public TipoCuentaComprador getTipoCuenta() {
        return tipoCuenta;
    }



    public void setTipoCuenta(TipoCuentaComprador tipoCuenta) {
        this.tipoCuenta = tipoCuenta;
    }



    public LocalDateTime getFechaInicioPremium() {
        return fechaInicioPremium;
    }



    public void setFechaInicioPremium(LocalDateTime fechaInicioPremium) {
        this.fechaInicioPremium = fechaInicioPremium;
    }

}
