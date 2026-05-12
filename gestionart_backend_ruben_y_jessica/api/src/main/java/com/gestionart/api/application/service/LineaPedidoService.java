package com.gestionart.api.application.service;

import java.util.Collection;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.models.LineaPedido;
import com.gestionart.api.domain.repository.LineaPedidoRepository;
import com.gestionart.api.exception.NotFoundByIdException;

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

    public List<LineaPedido> obtenerPorPedido(Long idPedido) {
        return lineaPedidoRepository.findByIdPedido(idPedido);
    }

    @Transactional(readOnly = true)
    public List<LineaPedido> obtenerPorVendedor(Long idVendedor) {
        return lineaPedidoRepository.findByVendedorId(idVendedor);
    }

}