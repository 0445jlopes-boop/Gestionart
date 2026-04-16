package com.gestionart.api.application.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.repository.CompradorRepository;
import com.gestionart.api.exception.NotFoundByIdException;

@Service
@Transactional
public class CompradorService {

    private final CompradorRepository compradorRepository;

    public CompradorService(CompradorRepository compradorRepository) {
        this.compradorRepository = compradorRepository;
    }

    public Comprador obtenerPorId(Long id) {
        return compradorRepository.findById(id).orElseThrow(() -> new NotFoundByIdException(id));

    }

    @Transactional(readOnly = true)
    public List<Comprador> listarTodos() {
        return compradorRepository.findAll();
    }

    public Comprador actualizar(Long id, Comprador datos) {

        Comprador comprador = obtenerPorId(id);

        comprador.setNombre(datos.getNombre());
        comprador.setDireccion(datos.getDireccion());
        comprador.setImagen(datos.getImagen());

        return compradorRepository.save(comprador);
    }

    public void eliminar(Long id) {
        compradorRepository.deleteById(id);
    }

    public Comprador obtenerPorCorreo(String correoElectronico) {
        return compradorRepository.findByCorreoElectronico(correoElectronico).orElse(null);
    }
}
