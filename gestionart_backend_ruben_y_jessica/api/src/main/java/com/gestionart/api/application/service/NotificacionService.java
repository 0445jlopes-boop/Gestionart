package com.gestionart.api.application.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.TipoNotificacion;
import com.gestionart.api.domain.models.Notificacion;
import com.gestionart.api.domain.repository.NotificacionRepository;

@Service
@Transactional
public class NotificacionService {
    private final NotificacionRepository notificacionRepository;
    private final VendedorService vendedorService;


    public NotificacionService(NotificacionRepository notificacionRepository, VendedorService vendedorService) {
        this.notificacionRepository = notificacionRepository;
        this.vendedorService = vendedorService; 
    }

    public Notificacion crearNotificacion(Long vendedorId, TipoNotificacion tipo) {
        vendedorService.obtenerPorId(vendedorId);
        Notificacion notificacion = new Notificacion();
        notificacion.setVendedorId(vendedorId);
        notificacion.setTipo(tipo);
        notificacion.setLeido(false);
        notificacion.setFecha(LocalDateTime.now());

        return notificacionRepository.save(notificacion);
    }

    @Transactional(readOnly = true)
    public List<Notificacion> obtenerPorVendedor(Long vendedorId) {
        vendedorService.obtenerPorId(vendedorId);
        return notificacionRepository.findByVendedorId(vendedorId);
    }

    @Transactional(readOnly = true)
    public List<Notificacion> obtenerNoLeidas(Long vendedorId) {
        vendedorService.obtenerPorId(vendedorId);
        return notificacionRepository
                .findByVendedorIdAndLeidoFalse(vendedorId, false);
    }

    @Transactional(readOnly = true)
    public List<Notificacion> obtenerLeidas(Long vendedorId) {
        vendedorService.obtenerPorId(vendedorId);
        return notificacionRepository
                .findByVendedorIdAndLeidoTrue(vendedorId, true);
    }

    @Transactional(readOnly = true)
    public List<Notificacion> obtenerPorVendedorYTipo(Long vendedorId, TipoNotificacion tipo) {
        vendedorService.obtenerPorId(vendedorId);
        
        return notificacionRepository
                .findByVendedorIdAndTipo(vendedorId, tipo);
    }

    public Notificacion obtenerPorId(Long id) {
        return notificacionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Notificación no encontrada"));
    }

    public Notificacion marcarComoLeida(Long id) {
        Notificacion notificacion = obtenerPorId(id);
        notificacion.setLeido(true);

        return notificacionRepository.save(notificacion);
    }

    public void marcarTodasComoLeidas(Long vendedorId) {

        List<Notificacion> notificaciones =
                notificacionRepository.findByVendedorIdAndLeidoFalse(vendedorId, false);

        for (Notificacion n : notificaciones) {
            n.setLeido(true);
            notificacionRepository.save(n);
        }
    }

    public void eliminar(Long id) {
        notificacionRepository.deleteById(id);
    }
}
