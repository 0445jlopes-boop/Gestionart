package com.gestionart.api.application.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.EstadoPago;
import com.gestionart.api.domain.models.Pago;
import com.gestionart.api.domain.repository.PagoRepository;

@Service
@Transactional
public class PagoService {

    private final PagoRepository pagoRepository;

    public PagoService(PagoRepository pagoRepository) {
        this.pagoRepository = pagoRepository;
    }

    public Pago registrar(Pago pago) {

        pago.setFecha(LocalDateTime.now());
        pago.setEstado(EstadoPago.PENDIENTE);

        return pagoRepository.save(pago);
    }

    public void confirmar(Long idPago) {

        Pago pago = pagoRepository.findById(idPago)
                .orElseThrow(() -> new RuntimeException("No encontrado"));

        pago.setEstado(EstadoPago.CONFIRMADO);
        pagoRepository.save(pago);
    }
}