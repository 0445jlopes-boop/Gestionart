package com.gestionart.api.domain.models;

import com.gestionart.api.domain.enums.Rol;

public class Vendedor extends Usuario {
    private String descripcionPerfil;
   
    public Vendedor() {
        super();
    }

    public Vendedor(String descripcionPerfil) {
        this.descripcionPerfil = descripcionPerfil;
    }

    public Vendedor(Long id, String correoElectronico, String nombre, String imagen, String contrasena, Rol rol,
            String descripcionPerfil) {
        super(id, correoElectronico, nombre, imagen, contrasena, rol);
        this.descripcionPerfil = descripcionPerfil;
    }

    public String getDescripcionPerfil() {
        return descripcionPerfil;
    }

    public void setDescripcionPerfil(String descripcionPerfil) {
        this.descripcionPerfil = descripcionPerfil;
    }

    
}
