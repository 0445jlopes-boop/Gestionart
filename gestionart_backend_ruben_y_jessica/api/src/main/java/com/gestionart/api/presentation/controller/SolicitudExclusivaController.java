package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.SolicitudExclusivaService;
import com.gestionart.api.common.mapper.SolicitudExclusivaMapper;
import com.gestionart.api.domain.enums.EstadoSolicitud;
import com.gestionart.api.domain.models.SolicitudExclusiva;
import com.gestionart.api.presentation.dto.request.SolicitudExclusivaRequest;
import com.gestionart.api.presentation.dto.response.SolicitudExclusivaResponse;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/solicitudes-exclusivas")
public class SolicitudExclusivaController {

    private final SolicitudExclusivaService solicitudService;
    private final SolicitudExclusivaMapper mapper;

    public SolicitudExclusivaController(SolicitudExclusivaService solicitudService,
                                        SolicitudExclusivaMapper mapper) {
        this.solicitudService = solicitudService;
        this.mapper = mapper;
    }

    @PostMapping
    public ResponseEntity<SolicitudExclusivaResponse> crear(@RequestBody SolicitudExclusivaRequest request) {

                SolicitudExclusiva solicitud = new SolicitudExclusiva();
                if(request.idComprador() == null || request.idArticulo() == null) {
                    return ResponseEntity.badRequest().build(); 
                }
                solicitud.setIdComprador(request.idComprador());
                solicitud.setIdArticulo(request.idArticulo());
                solicitud.setMensaje(request.mensaje());
                solicitud.setEstado(EstadoSolicitud.PENDIENTE);
                solicitud.setIdVendedor(request.idVendedor());
                solicitud.setFecha(java.time.LocalDateTime.now());
        return ResponseEntity.ok(mapper.toResponse(solicitudService.crear(solicitud)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<SolicitudExclusivaResponse> obtenerPorId(@PathVariable Long id) {
        return ResponseEntity.ok(mapper.toResponse(solicitudService.obtenerPorId(id)));
    }

    @GetMapping("/vendedor/{idVendedor}")
    public ResponseEntity<java.util.List<SolicitudExclusivaResponse>> obtenerPorIdVendedor(@PathVariable Long idVendedor) {
        return ResponseEntity.ok(solicitudService.obtenerPorIdVendedor(idVendedor)
                .stream()
                .map(mapper::toResponse)
                .toList());
    }

    @GetMapping("/vendedor/{idVendedor}/estado/{estado}")
    public ResponseEntity<java.util.List<SolicitudExclusivaResponse>> obtenerPorIdVendedorYEstado(@PathVariable Long idVendedor, @PathVariable EstadoSolicitud estado) {
        return ResponseEntity.ok(solicitudService.obtenerPorIdVendedorYEstado(idVendedor, estado)
                .stream()
                .map(mapper::toResponse)
                .toList());
    }

    @GetMapping("/comprador/{idComprador}/estado/{estado}")
    public ResponseEntity<java.util.List<SolicitudExclusivaResponse>> obtenerPorIdCompradorYEstado(@PathVariable Long idComprador, @PathVariable EstadoSolicitud estado) {
        return ResponseEntity.ok(solicitudService.obtenerPorIdCompradorYEstado(idComprador, estado)
                .stream()
                .map(mapper::toResponse)
                .toList());
    }

    @PutMapping("/{id}/estado")
    public ResponseEntity<SolicitudExclusivaResponse> actualizarEstado(@PathVariable Long id, @RequestParam EstadoSolicitud nuevoEstado) {
        return ResponseEntity.ok(mapper.toResponse(solicitudService.actualizarEstado(id, nuevoEstado)));
    }

    @GetMapping("/comprador/{idComprador}")
    public ResponseEntity<java.util.List<SolicitudExclusivaResponse>> obtenerPorComprador(@PathVariable Long idComprador) {
        return ResponseEntity.ok(solicitudService.obtenerPorComprador(idComprador)
                .stream()
                .map(mapper::toResponse)
                .toList());
    }

    @GetMapping
    public ResponseEntity<java.util.List<SolicitudExclusivaResponse>> obtenerTodas() {
        return ResponseEntity.ok(solicitudService.obtenerTodas()
                .stream()
                .map(mapper::toResponse)
                .toList());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarPorId(@PathVariable Long id) {
        solicitudService.eliminarPorId(id);
        return ResponseEntity.noContent().build();
    }


}