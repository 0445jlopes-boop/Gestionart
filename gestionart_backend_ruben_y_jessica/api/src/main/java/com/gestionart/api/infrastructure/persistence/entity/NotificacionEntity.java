package com.gestionart.api.infrastructure.persistence.entity;

import com.gestionart.api.domain.enums.TipoNotificacion;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "notificaciones")
public class NotificacionEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "vendedor_id")
    private VendedorEntity vendedor;

    @Enumerated(EnumType.STRING)
    private TipoNotificacion tipo;

    private boolean leido;

    private LocalDateTime fecha;

    public NotificacionEntity() {}

    public NotificacionEntity(Long id, VendedorEntity vendedor, TipoNotificacion tipo, boolean leido,
            LocalDateTime fecha) {
        this.id = id;
        this.vendedor = vendedor;
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

    public VendedorEntity getVendedor() {
        return vendedor;
    }

    public void setVendedor(VendedorEntity vendedor) {
        this.vendedor = vendedor;
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
    
}
