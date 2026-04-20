package com.gestionart.api.application.service;

import java.util.Collection;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.domain.repository.LineaPedidoRepository;
import com.gestionart.api.exception.NotFoundByIdException;
import com.gestionart.api.presentation.dto.response.LineaPedidoResponse;

@Service
@Transactional
public class LineaPedidoService {

    private final LineaPedidoRepository lineaPedidoRepository;

    public LineaPedidoService(LineaPedidoRepository lineaPedidoRepository) {
        this.lineaPedidoRepository = lineaPedidoRepository;
    }

    public LineaPedido crear(LineaPedido lineaPedido) {
        return lineaPedidoRepository.save(lineaPedido);
    }

    @Transactional(readOnly = true)
    public LineaPedido obtenerPorId(Long id) {
        return lineaPedidoRepository.findById(id).orElseThrow(() -> new NotFoundByIdException(id));
    }


    public void eliminar(Long id) {
        lineaPedidoRepository.deleteById(id);
    }

    public LineaPedido obtenerPorPedido(Long idPedido) {
        return lineaPedidoRepository.findByIdPedido(idPedido).orElseThrow(() -> new NotFoundByIdException(idPedido));
     
    }

}