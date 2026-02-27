package com.gestionart.api.domain.models;

import java.time.LocalDateTime;

import com.gestionart.api.domain.enums.EstadoSolicitud;

public class SolicitudExclusiva {
    private Long id;
    private Long idComprador;
    private Long idArticulo;
    private Long idVendedor;
    private String mensaje;
    private EstadoSolicitud estado;
    private LocalDateTime fecha;
    
    public SolicitudExclusiva() {
    }

    public SolicitudExclusiva(Long id, Long idComprador, Long idArticulo, Long idVendedor, String mensaje,EstadoSolicitud estado, LocalDateTime fecha) {
        this.id = id;
        this.idComprador = idComprador;
        this.idArticulo = idArticulo;
        this.idVendedor = idVendedor;
        this.mensaje = mensaje;
        this.estado = estado;
        this.fecha = fecha;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getIdComprador() {
        return idComprador;
    }

    public void setIdComprador(Long idComprador) {
        this.idComprador = idComprador;
    }

    public Long getIdArticulo() {
        return idArticulo;
    }

    public void setIdArticulo(Long idArticulo) {
        this.idArticulo = idArticulo;
    }

    public Long getIdVendedor() {
        return idVendedor;
    }

    public void setIdVendedor(Long idVendedor) {
        this.idVendedor = idVendedor;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public EstadoSolicitud getEstado() {
        return estado;
    }

    public void setEstado(EstadoSolicitud estado) {
        this.estado = estado;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

}
