package com.gestionart.api.application.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.gestionart.api.domain.enums.TipoCuentaComprador;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.models.Vendedor;
import com.gestionart.api.domain.repository.CompradorRepository;
import com.gestionart.api.domain.repository.VendedorRepository;

@Service
public class AutenticacionService {

    private final CompradorRepository compradorRepository;
    private final VendedorRepository vendedorRepository;
    private final PasswordEncoder passwordEncoder;

    public AutenticacionService(CompradorRepository compradorRepository,
                                VendedorRepository vendedorRepository,
                                PasswordEncoder passwordEncoder) {
        this.compradorRepository = compradorRepository;
        this.vendedorRepository = vendedorRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Comprador registrarComprador(Comprador comprador) {
        if (compradorRepository.findByCorreoElectronico(comprador.getCorreoElectronico()).isPresent()) {
            throw new RuntimeException("Correo ya registrado");
        }
        comprador.setContrasena(passwordEncoder.encode(comprador.getContrasena()));
        comprador.setTipoCuenta(TipoCuentaComprador.NORMAL);
        return compradorRepository.save(comprador);
    }

    public Vendedor registrarVendedor(Vendedor vendedor) {
        if (vendedorRepository.findByCorreoElectronico(vendedor.getCorreoElectronico()).isPresent()) {
            throw new RuntimeException("Correo ya registrado");
        }
        vendedor.setContrasena(passwordEncoder.encode(vendedor.getContrasena()));
        return vendedorRepository.save(vendedor);
    }

    public String login(String correo, String contrasena) {
        return "TOKEN_SIMULADO";
    }
}
