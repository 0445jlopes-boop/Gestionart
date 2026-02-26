package com.gestionart.api.domain.models;

public class Comprador {
    private Long id; //Identificador largo aleatorio que no necesita de bbdd para generarse y aumenta la seguridad
    private String correoElectronico;
    private String nombre;
    private String imagen;
    private String contrasena;
    private String direccion;

    public Comprador() {
    }

    public Comprador(Long id, String correoElectronico, String nombre, String imagen, String contrasena, String direccion) {
        this.id = id;
        this.correoElectronico = correoElectronico;
        this.nombre = nombre;
        this.imagen = imagen;
        this.contrasena = contrasena;
        this.direccion = direccion;
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

    
    

}
