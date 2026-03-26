package com.gestionart.api.application.service;

import java.time.LocalDateTime;
import java.util.List;

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

    public Anuncio crear(Anuncio anuncio) {
        anuncio.setActivo(false);
        return anuncioRepository.save(anuncio);
    }

    @Transactional(readOnly = true)
    public List<Anuncio> obtenerTodos() {
        return anuncioRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Anuncio obtenerPorId(Long id) {
        return anuncioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Anuncio no encontrado"));
    }

    public void eliminar(Long id) {
        anuncioRepository.deleteById(id);
    }

    public Anuncio activarPublicidad(Long idAnuncio) {

        Anuncio anuncio = anuncioRepository.findById(idAnuncio)
                .orElseThrow(() -> new RuntimeException("Anuncio no encontrado"));

        anuncio.setActivo(true);
        anuncio.setFechaInicio(LocalDateTime.now());
        anuncio.setFechaFin(LocalDateTime.now().plusDays(30));

        return anuncioRepository.save(anuncio);
    }
}
