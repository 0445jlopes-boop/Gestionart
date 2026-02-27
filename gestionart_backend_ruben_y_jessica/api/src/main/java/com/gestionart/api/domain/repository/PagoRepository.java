package com.gestionart.api.domain.repository;

import java.util.List;
import java.util.Optional;

import com.gestionart.api.domain.enums.EstadoPago;
import com.gestionart.api.domain.enums.TipoPago;
import com.gestionart.api.domain.models.Pago;

public interface PagoRepository {
    Pago save(Pago pago);
    Optional<Pago> findById(Long id);
    List<Pago> findByTipoPago(TipoPago tipoPago);
    List<Pago> findByReferenciaId(Long referenciaId);
    Optional<Pago> findByReferenciaExterna(String referenciaExterna);
    List<Pago> findByEstado(EstadoPago estado);
    List<Pago> findAll(); 
}
