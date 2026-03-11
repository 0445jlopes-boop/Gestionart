package com.gestionart.api.presentation.dto.request;

import com.gestionart.api.domain.enums.TipoNotificacion;

public class CrearNotificacionRequest {

    private Long vendedorId;
    private TipoNotificacion tipo;

    public Long getVendedorId() {
        return vendedorId;
    }

    public void setVendedorId(Long vendedorId) {
        this.vendedorId = vendedorId;
    }

    public TipoNotificacion getTipo() {
        return tipo;
    }

    public void setTipo(TipoNotificacion tipo) {
        this.tipo = tipo;
    }
}
