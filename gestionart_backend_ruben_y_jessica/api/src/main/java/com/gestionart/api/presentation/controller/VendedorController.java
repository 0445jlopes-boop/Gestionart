package com.gestionart.api.presentation.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.gestionart.api.application.service.VendedorService;
import com.gestionart.api.domain.models.Vendedor;
import com.gestionart.api.presentation.dto.request.VendedorRequest;
import com.gestionart.api.presentation.dto.response.VendedorResponse;
import com.gestionart.api.presentation.mapper.VendedorMapper;

@RestController
@RequestMapping("/vendedores")
public class VendedorController {

    private final VendedorService vendedorService;

    public VendedorController(VendedorService vendedorService) {
        this.vendedorService = vendedorService;
    }

    @PostMapping
    public ResponseEntity<VendedorResponse> crear(@RequestBody VendedorRequest request) {

        Vendedor vendedor = new Vendedor();
        vendedor.setNombre(request.getNombre());
        vendedor.setCorreoElectronico(request.getCorreoElectronico());
        vendedor.setContrasena(request.getContrasena());
        vendedor.setDescripcionPerfil(request.getDescripcionPerfil());

        return ResponseEntity.ok(
                VendedorMapper.toResponse(vendedorService.crear(vendedor)));
    }
}