package com.gestionart.api.infrastructure.persistence.entity;

import com.gestionart.api.domain.enums.Rol;

import jakarta.persistence.*;

@Entity
@Table(name = "vendedores")
@PrimaryKeyJoinColumn(name = "id")
public class VendedorEntity extends UsuarioEntity {

    private String descripcionPerfil;

    public VendedorEntity() {}
    

    public VendedorEntity(Long id, String correoElectronico, String nombre, String imagen, String contrasena, Rol rol,
            String descripcionPerfil) {
        super(id, correoElectronico, nombre, imagen, contrasena, rol);
        this.descripcionPerfil = descripcionPerfil;
    }


    public VendedorEntity(String descripcionPerfil) {
        this.descripcionPerfil = descripcionPerfil;
    }


    public String getDescripcionPerfil() { return descripcionPerfil; }

    public void setDescripcionPerfil(String descripcionPerfil) {
        this.descripcionPerfil = descripcionPerfil;
    }
}
