package com.gestionart.api.application.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.Categoria;
import com.gestionart.api.domain.models.Anuncio;
import com.gestionart.api.domain.repository.AnuncioRepository;
import com.gestionart.api.exception.NotFoundByIdException;
import com.gestionart.api.exception.NotfoundByCategoriaException;

@Service
@Transactional
public class AnuncioService {

    private final AnuncioRepository anuncioRepository;

    public AnuncioService(AnuncioRepository anuncioRepository) {
        this.anuncioRepository = anuncioRepository;
    }

    public Anuncio crear(Anuncio anuncio) {
        anuncio.setActivo(true);
        anuncio.setFechaInicio(LocalDateTime.now());
        anuncio.setFechaFin(LocalDateTime.now().plusDays(30));
        //anuncio.setCategoria(null);
        return anuncioRepository.save(anuncio);
    }

    @Transactional(readOnly = true)
    public List<Anuncio> obtenerTodos() {
        return anuncioRepository.findAll();
    }

    public Anuncio obtenerPorId(Long id) {
        return anuncioRepository.findById(id)
                .orElseThrow(() -> new NotFoundByIdException(id));
    }

    public Anuncio obtenerPorIdVendedor(Long idVendedor) {
        return anuncioRepository.findByIdVendedor(idVendedor)
                .orElseThrow(() -> new NotFoundByIdException(idVendedor));
    }

    public Anuncio obtenerPorCategoria(Categoria categoria) {
        return anuncioRepository.findByCategoria(categoria)
                .orElseThrow(() -> new NotfoundByCategoriaException(categoria.toString()));
    }

    public Anuncio actualizar(Long id, Anuncio datos) {

        Anuncio anuncio = obtenerPorId(id);
        if(datos.getTitulo() != null) {
            anuncio.setTitulo(datos.getTitulo());
        }
        if(datos.getCategoria() != null) {
            anuncio.setCategoria(datos.getCategoria());
        }
        if(datos.getPrecio() != 0) {
            anuncio.setPrecio(datos.getPrecio());
        }
        if(datos.getImagen() != null) {
            anuncio.setImagen(datos.getImagen());
        }

        return anuncioRepository.save(anuncio);
    }

    public void eliminar(Long id) {
        anuncioRepository.deleteById(id);
    }
}
