package com.gestionart.api.domain.models;

import java.time.LocalDateTime;

import com.gestionart.api.domain.enums.EstadoPago;
import com.gestionart.api.domain.enums.TipoPago;

public class Pago {
    private Long id;
    private TipoPago tipoPago;      
    private Long referenciaId;    
    private double importe;
    private EstadoPago estado;
    private String referenciaExterna;
    private LocalDateTime fecha;
   
    public Pago() {
    }

    public Pago(Long id, TipoPago tipoPago, Long referenciaId, double importe, EstadoPago estado,
            String referenciaExterna, LocalDateTime fecha) {
        this.id = id;
        this.tipoPago = tipoPago;
        this.referenciaId = referenciaId;
        this.importe = importe;
        this.estado = estado;
        this.referenciaExterna = referenciaExterna;
        this.fecha = fecha;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public TipoPago getTipoPago() {
        return tipoPago;
    }

    public void setTipoPago(TipoPago tipoPago) {
        this.tipoPago = tipoPago;
    }

    public Long getReferenciaId() {
        return referenciaId;
    }

    public void setReferenciaId(Long referenciaId) {
        this.referenciaId = referenciaId;
    }

    public double getImporte() {
        return importe;
    }

    public void setImporte(double importe) {
        this.importe = importe;
    }

    public EstadoPago getEstado() {
        return estado;
    }

    public void setEstado(EstadoPago estado) {
        this.estado = estado;
    }

    public String getReferenciaExterna() {
        return referenciaExterna;
    }

    public void setReferenciaExterna(String referenciaExterna) {
        this.referenciaExterna = referenciaExterna;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

}

