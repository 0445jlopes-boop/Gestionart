package com.gestionart.api.infrastructure.persistence.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "suscripciones")
public class SuscripcionEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "comprador_id")
    private CompradorEntity comprador;

    private LocalDateTime fechaInicio;
    private LocalDateTime fechaFin;
    private boolean activa;

    public SuscripcionEntity() {}
    
    public SuscripcionEntity(Long id, CompradorEntity comprador, LocalDateTime fechaInicio, LocalDateTime fechaFin,
            boolean activa) {
        this.id = id;
        this.comprador = comprador;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.activa = activa;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public CompradorEntity getComprador() {
        return comprador;
    }

    public void setComprador(CompradorEntity comprador) {
        this.comprador = comprador;
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

    public boolean isActiva() {
        return activa;
    }

    public void setActiva(boolean activa) {
        this.activa = activa;
    }
    
}
