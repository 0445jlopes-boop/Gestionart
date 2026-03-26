package com.gestionart.api.domain.models;

import java.time.LocalDateTime;

import com.gestionart.api.domain.enums.Rol;
import com.gestionart.api.domain.enums.TipoCuentaComprador;

public class Comprador extends Usuario{
    private String direccion;
    private TipoCuentaComprador tipoCuenta;
    private LocalDateTime fechaInicioPremium;
    private LocalDateTime fechaFinPremium;

    public Comprador() {
        super();
    }

    public Comprador(String direccion, TipoCuentaComprador tipoCuenta, LocalDateTime fechaInicioPremium,
            LocalDateTime fechaFinPremium) {
        this.direccion = direccion;
        this.tipoCuenta = tipoCuenta;
        this.fechaInicioPremium = fechaInicioPremium;
        this.fechaFinPremium = fechaFinPremium;
    }

    public Comprador(Long id, String correoElectronico, String nombre, String imagen, String contrasena, Rol rol,
            String direccion, TipoCuentaComprador tipoCuenta, LocalDateTime fechaInicioPremium,
            LocalDateTime fechaFinPremium) {
        super(id, correoElectronico, nombre, imagen, contrasena, rol);
        this.direccion = direccion;
        this.tipoCuenta = tipoCuenta;
        this.fechaInicioPremium = fechaInicioPremium;
        this.fechaFinPremium = fechaFinPremium;
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



    public LocalDateTime getFechaFinPremium() {
        return fechaFinPremium;
    }



    public void setFechaFinPremium(LocalDateTime fechaFinPremium) {
        this.fechaFinPremium = fechaFinPremium;
    }



    public String getDireccion() {
        return direccion;
    }



    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

}
