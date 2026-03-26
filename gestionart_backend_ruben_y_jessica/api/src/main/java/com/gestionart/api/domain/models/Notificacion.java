package com.gestionart.api.domain.models;

import java.time.LocalDateTime;

import com.gestionart.api.domain.enums.TipoNotificacion;

public class Notificacion {
    private Long id;
    private Long vendedorid;
    private TipoNotificacion tipo; 
    private boolean leido;
    private LocalDateTime fecha;
    
    public Notificacion() {
    }

    public Notificacion(Long id, Long vendedorid, TipoNotificacion tipo, boolean leido, LocalDateTime fecha) {
        this.id = id;
        this.vendedorid = vendedorid;
        this.tipo = tipo;
        this.leido = leido;
        this.fecha = fecha;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getVendedorId() {
        return vendedorid;
    }

    public void setVendedorId(Long vendedorid) {
        this.vendedorid = vendedorid;
    }

    public TipoNotificacion getTipo() {
        return tipo;
    }

    public void setTipo(TipoNotificacion tipo) {
        this.tipo = tipo;
    }

    public boolean isLeido() {
        return leido;
    }

    public void setLeido(boolean leido) {
        this.leido = leido;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

    public Long getVendedorid() {
        return vendedorid;
    }

    public void setVendedorid(Long vendedorid) {
        this.vendedorid = vendedorid;
    }

    
}
