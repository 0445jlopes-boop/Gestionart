package com.gestionart.api.application.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.EstadoSolicitud;
import com.gestionart.api.domain.models.SolicitudExclusiva;
import com.gestionart.api.domain.repository.SolicitudExclusivaRepository;
import com.gestionart.api.exception.NotFoundByIdException;

@Service
@Transactional
public class SolicitudExclusivaService {

    private final SolicitudExclusivaRepository repository;

    public SolicitudExclusivaService(SolicitudExclusivaRepository repository) {
        this.repository = repository;
    }

    public SolicitudExclusiva crear(SolicitudExclusiva solicitud) {

        solicitud.setFecha(LocalDateTime.now());
        solicitud.setEstado(EstadoSolicitud.PENDIENTE);

        return repository.save(solicitud);
    }

    public SolicitudExclusiva obtenerPorId(Long id) {
        return repository.findById(id).orElseThrow(() -> new NotFoundByIdException(id));
    }

    public List<SolicitudExclusiva> obtenerPorIdVendedor(Long idVendedor) {
        return repository.findByIdVendedor(idVendedor);
    }

    public List<SolicitudExclusiva> obtenerPorIdVendedorYEstado(Long idVendedor, EstadoSolicitud estado) {
        return repository.findByIdVendedorAndEstado(idVendedor, estado);
    }

    public List<SolicitudExclusiva> obtenerPorIdCompradorYEstado(Long idComprador, EstadoSolicitud estado) {
        return  repository.findByIdCompradorAndEstado(idComprador, estado);
    }

    public SolicitudExclusiva actualizarEstado(Long id, EstadoSolicitud nuevoEstado) {
        SolicitudExclusiva solicitud = obtenerPorId(id);
        solicitud.setEstado(nuevoEstado);
        return repository.save(solicitud);
    }

    public List <SolicitudExclusiva> obtenerPorComprador (Long idComprador) {
        return repository.findByIdComprador(idComprador);
    }

    public List<SolicitudExclusiva> obtenerTodas() {
        return repository.findAll();
    }

    public void eliminarPorId(Long id) {
        repository.deleteById(id);
    }

}