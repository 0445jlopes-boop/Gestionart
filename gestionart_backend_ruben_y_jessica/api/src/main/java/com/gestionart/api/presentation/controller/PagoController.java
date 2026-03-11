package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.PagoService;
import com.gestionart.api.domain.models.Pago;
import com.gestionart.api.presentation.dto.request.CrearPagoRequest;

@RestController
@RequestMapping("/pagos")
public class PagoController {

    private final PagoService pagoService;

    public PagoController(PagoService pagoService) {
        this.pagoService = pagoService;
    }

    @PostMapping
    public ResponseEntity<Pago> pagar(@RequestBody CrearPagoRequest request) {

        Pago pago = new Pago();
        pago.setReferenciaId(request.getIdPedido());
        pago.setImporte(request.getMonto());

        return ResponseEntity.ok(pagoService.registrar(pago));
    }
}