package com.gestionart.api.domain.models;

import java.time.LocalDateTime;

public class Notificacion {
    private long id;
    private long vendedorid;
    private String tipo; //Stock acabado, solicitud de creación, nuevo pedido
    private boolean leido;
    private LocalDateTime fecha;
    
    public Notificacion() {
    }

    public Notificacion(long id, long vendedorid, String tipo, boolean leido, LocalDateTime fecha) {
        this.id = id;
        this.vendedorid = vendedorid;
        this.tipo = tipo;
        this.leido = leido;
        this.fecha = fecha;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getVendedorid() {
        return vendedorid;
    }

    public void setVendedorid(long vendedorid) {
        this.vendedorid = vendedorid;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
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

    
}
