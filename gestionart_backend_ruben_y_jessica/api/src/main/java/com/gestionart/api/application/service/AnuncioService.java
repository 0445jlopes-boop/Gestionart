package com.gestionart.api.application.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.models.Anuncio;
import com.gestionart.api.domain.repository.AnuncioRepository;

@Service
@Transactional
public class AnuncioService {

    private final AnuncioRepository anuncioRepository;

    public AnuncioService(AnuncioRepository anuncioRepository) {
        this.anuncioRepository = anuncioRepository;
    }

    public Anuncio activarPublicidad(Long idAnuncio) {

        Anuncio anuncio = anuncioRepository.findById(idAnuncio)
                .orElseThrow(() -> new RuntimeException("No encontrado"));

        anuncio.setActivo(true);
        anuncio.setFechaInicio(LocalDateTime.now());
        anuncio.setFechaFin(LocalDateTime.now().plusDays(30));

        return anuncioRepository.save(anuncio);
    }
}
