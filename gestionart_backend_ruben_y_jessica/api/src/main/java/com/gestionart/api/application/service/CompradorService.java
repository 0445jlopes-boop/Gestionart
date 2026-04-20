package com.gestionart.api.application.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.TipoCuentaComprador;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.repository.CompradorRepository;
import com.gestionart.api.exception.NotFoundByCorreoException;
import com.gestionart.api.exception.NotFoundByIdException;
import com.gestionart.api.exception.NotFoundByNombreException;

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
        if(datos.getNombre() != null) {
            comprador.setNombre(datos.getNombre());
        }
        if(datos.getCorreoElectronico() != null) {
            comprador.setCorreoElectronico(datos.getCorreoElectronico());
        }
        if(datos.getDireccion() != null) {
            comprador.setDireccion(datos.getDireccion());
        }
        if(datos.getImagen() != null) {
            comprador.setImagen(datos.getImagen());
        }
        if(datos.getContrasena() != null) {
            comprador.setContrasena(datos.getContrasena());
        }

        return compradorRepository.save(comprador);
    }

    public void eliminar(Long id) {
        compradorRepository.deleteById(id);
    }

    public Comprador obtenerPorCorreo(String correoElectronico) {
        return compradorRepository.findByCorreoElectronico(correoElectronico).orElseThrow(() -> new NotFoundByCorreoException(correoElectronico));
    }

    public Comprador obtenerPorNombre(String nombre) {
        return compradorRepository.findByNombre(nombre).orElseThrow(() -> new NotFoundByNombreException(nombre));
    }

    public void activarPremium(Long id) {
        Comprador comprador = obtenerPorId(id);
        comprador.setTipoCuenta(TipoCuentaComprador.PREMIUM);
        comprador.setFechaInicioPremium(java.time.LocalDateTime.now());
        comprador.setFechaFinPremium(java.time.LocalDateTime.now().plusMonths(3));  
        compradorRepository.save(comprador);
    }

    public void desactivarPremium(Long id) {
        Comprador comprador = obtenerPorId(id);
        comprador.setTipoCuenta(TipoCuentaComprador.NORMAL);
        comprador.setFechaInicioPremium(null);
        comprador.setFechaFinPremium(null);
        compradorRepository.save(comprador);
    }
}
