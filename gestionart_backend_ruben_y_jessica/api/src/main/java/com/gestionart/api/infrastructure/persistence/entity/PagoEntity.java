package com.gestionart.api.infrastructure.persistence.entity;

import com.gestionart.api.domain.enums.EstadoPago;
import com.gestionart.api.domain.enums.TipoPago;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "pagos")
public class PagoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    private TipoPago tipoPago;

    private Long referenciaId;

    private double importe;

    @Enumerated(EnumType.STRING)
    private EstadoPago estado;

    private String referenciaExterna;

    private LocalDateTime fecha;

    public PagoEntity() {}

    public PagoEntity(Long id, TipoPago tipoPago, Long referenciaId, double importe, EstadoPago estado,
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
