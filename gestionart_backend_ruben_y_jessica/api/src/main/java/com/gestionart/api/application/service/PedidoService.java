package com.gestionart.api.application.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.sound.sampled.Line;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.EstadoPedido;
import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.domain.models.Pedido;
import com.gestionart.api.domain.repository.PedidoRepository;
import com.gestionart.api.exception.NotFoundByIdException;

@Service
@Transactional
public class PedidoService {

    private final PedidoRepository pedidoRepository;
    private final LineaPedidoService lineaPedidoService;

    public PedidoService(PedidoRepository pedidoRepository, LineaPedidoService lineaPedidoService   ) {
        this.pedidoRepository = pedidoRepository;
        this.lineaPedidoService = lineaPedidoService;
    }

    public Pedido crear(Pedido pedido) {
        return pedidoRepository.save(pedido);
    }

    public void cancelar(Long idPedido) {

        Pedido pedido = pedidoRepository.findById(idPedido)
                .orElseThrow(() -> new NotFoundByIdException(idPedido));
        pedido.setFechaConfirmacion(null);
        pedido.setEstado(EstadoPedido.CANCELADO);
        pedidoRepository.save(pedido);
    }

    public void cambiarEstado(Long id) {
        Pedido pedido = pedidoRepository.findById(id)
                .orElseThrow(() -> new NotFoundByIdException(id));

        if (pedido.getEstado() == EstadoPedido.PENDIENTE) {
            pedido.setEstado(EstadoPedido.CONFIRMADO);
            pedido.setFechaConfirmacion(LocalDateTime.now());
        } else if (pedido.getEstado() == EstadoPedido.CONFIRMADO) {
            pedido.setEstado(EstadoPedido.PROCESANDO);
        }else if (pedido.getEstado() == EstadoPedido.PROCESANDO) {
            pedido.setEstado(EstadoPedido.FINALIZADO);
        }

        pedidoRepository.save(pedido);
    }

    public Pedido obtenerPorId(Long id) {
        return pedidoRepository.findById(id).orElseThrow(() -> new NotFoundByIdException(id));
    }

    public List<Pedido> obtenerPorIdCompradorYEstado(Long idComprador, EstadoPedido estado) {
        return pedidoRepository.findByIdCompradorAndEstado(idComprador, estado);
    }

    public List<Pedido> obtenerPorIdComprador(Long idComprador) {
        return pedidoRepository.findByIdComprador(idComprador);
    }

    public void eliminarPorId(Long id) {
        pedidoRepository.deleteById(id);    
    }

    public Pedido anadirLinea(Long idPedido, Long idLinea) {
        Pedido pedido = pedidoRepository.findById(idPedido)
                .orElseThrow(() -> new NotFoundByIdException(idPedido));
        
        if (pedido.getLineas() == null) {
            pedido.setLineas(new ArrayList<>());
        }
                pedido.getLineas().add(lineaPedidoService.obtenerPorId(idLinea));
        return pedidoRepository.save(pedido);
    }


}