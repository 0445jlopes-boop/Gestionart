package com.gestionart.api.application.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.TipoCuentaComprador;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.repository.CompradorRepository;

@Service
@Transactional
public class SuscripcionService {

    private final CompradorRepository compradorRepository;

    public SuscripcionService(CompradorRepository compradorRepository) {
        this.compradorRepository = compradorRepository;
    }

    public void activarPremium(Long idComprador) {

        Comprador comprador = compradorRepository.findById(idComprador)
                .orElseThrow(() -> new RuntimeException("No encontrado"));

        comprador.setTipoCuenta(TipoCuentaComprador.PREMIUM);
        comprador.setFechaInicioPremium(LocalDateTime.now());
        comprador.setFechaFinPremium(LocalDateTime.now().plusMonths(3));

        compradorRepository.save(comprador);
    }

    public void renovarPremium(Long idComprador) {

        Comprador comprador = compradorRepository.findById(idComprador)
                .orElseThrow(() -> new RuntimeException("No encontrado"));

        comprador.setFechaFinPremium(
                comprador.getFechaFinPremium().plusMonths(3)
        );

        compradorRepository.save(comprador);
    }

    public void verificarExpiracion(Long idComprador) {

        Comprador comprador = compradorRepository.findById(idComprador)
                .orElseThrow(() -> new RuntimeException("No encontrado"));

        if (comprador.getFechaFinPremium() != null &&
            comprador.getFechaFinPremium().isBefore(LocalDateTime.now())) {

            comprador.setTipoCuenta(TipoCuentaComprador.NORMAL);
            comprador.setFechaInicioPremium(null);
            comprador.setFechaFinPremium(null);

            compradorRepository.save(comprador);
        }
    }
}
