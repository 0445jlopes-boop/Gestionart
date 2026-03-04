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

    public NotificacionService(NotificacionRepository notificacionRepository) {
        this.notificacionRepository = notificacionRepository;
    }

    /*
     * Crear notificación interna
     */
    public Notificacion crearNotificacion(Long vendedorId, TipoNotificacion tipo) {

        if (vendedorId == null || tipo == null) {
            throw new IllegalArgumentException("Datos inválidos para crear notificación");
        }

        Notificacion notificacion = new Notificacion();
        notificacion.setVendedorid(vendedorId);
        notificacion.setTipo(tipo);
        notificacion.setLeido(false);
        notificacion.setFecha(LocalDateTime.now());

        return notificacionRepository.save(notificacion);
    }

    /*
     * Listar todas las notificaciones de un vendedor
     */
    @Transactional(readOnly = true)
    public List<Notificacion> obtenerPorVendedor(Long vendedorId) {

        if (vendedorId == null) {
            throw new IllegalArgumentException("VendedorId inválido");
        }

        return notificacionRepository.findByVendedorId(vendedorId);
    }

    /*
     * Listar no leídas
     */
    @Transactional(readOnly = true)
    public List<Notificacion> obtenerNoLeidas(Long vendedorId) {
        return notificacionRepository
                .findByVendedorIdAndLeidoFalse(vendedorId, false);
    }

    /*
     * Listar leídas
     */
    @Transactional(readOnly = true)
    public List<Notificacion> obtenerLeidas(Long vendedorId) {
        return notificacionRepository
                .findByVendedorIdAndLeidoTrue(vendedorId, true);
    }

    /*
     * Filtrar por tipo
     */
    @Transactional(readOnly = true)
    public List<Notificacion> obtenerPorTipo(Long vendedorId, TipoNotificacion tipo) {
        return notificacionRepository
                .findByVendedorIdAndTipo(vendedorId, tipo);
    }

    /*
     * Marcar como leída
     */
    public Notificacion marcarComoLeida(Long id, Long vendedorId) {

        List<Notificacion> notificaciones = 
                notificacionRepository.findByVendedorId(vendedorId);

        Notificacion notificacion = notificaciones.stream()
                .filter(n -> n.getId().equals(id))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Notificación no encontrada"));

        notificacion.setLeido(true);

        return notificacionRepository.save(notificacion);
    }

    /*
     * Marcar todas como leídas
     */
    public void marcarTodasComoLeidas(Long vendedorId) {

        List<Notificacion> notificaciones =
                notificacionRepository.findByVendedorIdAndLeidoFalse(vendedorId, false);

        for (Notificacion n : notificaciones) {
            n.setLeido(true);
            notificacionRepository.save(n);
        }
    }

    /*
     * Eliminar notificación
     */
    public void eliminar(Long id) {
        notificacionRepository.deleteById(id);
    }
}
