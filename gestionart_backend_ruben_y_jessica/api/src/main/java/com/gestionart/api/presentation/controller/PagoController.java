package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.PagoService;
import com.gestionart.api.common.mapper.PagoMapper;
import com.gestionart.api.domain.models.Pago;
import com.gestionart.api.presentation.dto.request.PagoRequest;
import com.gestionart.api.presentation.dto.response.PagoResponse;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/pagos")
public class PagoController {

    private final PagoService pagoService;
    private final PagoMapper pagoMapper;

    public PagoController(PagoService pagoService, PagoMapper pagoMapper) {
        this.pagoService = pagoService;
        this.pagoMapper = pagoMapper;
    }

    @PostMapping
    public ResponseEntity<PagoResponse> registrar(@RequestBody PagoRequest request) {

        Pago pago = new Pago(
                null,
                request.tipoPago(),
                request.referenciaId(),
                request.importe(),
                null,
                null,
                null
        );

        Pago registrado = pagoService.registrar(pago);

        return ResponseEntity.ok(pagoMapper.toResponse(registrado));
    }
}