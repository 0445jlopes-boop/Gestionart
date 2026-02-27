package com.gestionart.api.domain.models;

import com.gestionart.api.domain.enums.Rol;

public class Usuario {
    private Long id;
    private String correoElectronico;
    private String nombre;
    private String imagen;
    private String contrasena;
    private Rol rol;
    public Usuario() {
    }
    public Usuario(Long id, String correoElectronico, String nombre, String imagen, String contrasena, Rol rol) {
        this.id = id;
        this.correoElectronico = correoElectronico;
        this.nombre = nombre;
        this.imagen = imagen;
        this.contrasena = contrasena;
        this.rol = rol;
    }
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
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
    public Rol getRol() {
        return rol;
    }
    public void setRol(Rol rol) {
        this.rol = rol;
    }

    
}
