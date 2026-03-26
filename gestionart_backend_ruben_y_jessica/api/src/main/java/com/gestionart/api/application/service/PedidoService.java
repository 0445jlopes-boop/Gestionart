package com.gestionart.api.application.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.EstadoPedido;
import com.gestionart.api.domain.models.Pedido;
import com.gestionart.api.domain.repository.PedidoRepository;

@Service
@Transactional
public class PedidoService {

    private final PedidoRepository pedidoRepository;

    public PedidoService(PedidoRepository pedidoRepository) {
        this.pedidoRepository = pedidoRepository;
    }

    public Pedido crear(Long idComprador) {

        Pedido pedido = new Pedido();
        pedido.setIdComprador(idComprador);
        pedido.setFechaCreacion(LocalDateTime.now());
        pedido.setEstado(EstadoPedido.PENDIENTE);

        return pedidoRepository.save(pedido);
    }

    public void confirmar(Long idPedido) {

        Pedido pedido = pedidoRepository.findById(idPedido)
                .orElseThrow(() -> new RuntimeException("No encontrado"));

        pedido.setEstado(EstadoPedido.CONFIRMADO);
        pedidoRepository.save(pedido);
    }
}