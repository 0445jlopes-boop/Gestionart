package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.PagoService;
import com.gestionart.api.domain.models.Pago;
import com.gestionart.api.presentation.dto.request.PagoRequest;
import com.gestionart.api.presentation.dto.response.PagoResponse;
import com.gestionart.api.presentation.mapper.PagoMapper;

@RestController
@RequestMapping("/pagos")
public class PagoController {

    private final PagoService pagoService;

    public PagoController(PagoService pagoService) {
        this.pagoService = pagoService;
    }

    @PostMapping
    public ResponseEntity<PagoResponse> crear(@RequestBody PagoRequest request) {

        Pago pago = new Pago();
        pago.setIdPedido(request.getIdPedido());
        pago.setCantidad(request.getCantidad());
        pago.setTipo(request.getTipo());

        return ResponseEntity.ok(
                PagoMapper.toResponse(pagoService.registrar(pago)));
    }
}package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.PagoService;
import com.gestionart.api.domain.models.Pago;
import com.gestionart.api.presentation.dto.request.PagoRequest;
import com.gestionart.api.presentation.dto.response.PagoResponse;
import com.gestionart.api.presentation.mapper.PagoMapper;

@RestController
@RequestMapping("/pagos")
public class PagoController {

    private final PagoService pagoService;

    public PagoController(PagoService pagoService) {
        this.pagoService = pagoService;
    }

    @PostMapping
    public ResponseEntity<PagoResponse> crear(@RequestBody PagoRequest request) {

        Pago pago = new Pago();
        pago.setIdPedido(request.getIdPedido());
        pago.setCantidad(request.getCantidad());
        pago.setTipo(request.getTipo());

        return ResponseEntity.ok(
                PagoMapper.toResponse(pagoService.registrar(pago)));
    }
}