package com.gestionart.api.application.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.TipoCuentaComprador;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.models.Vendedor;
import com.gestionart.api.domain.repository.CompradorRepository;
import com.gestionart.api.domain.repository.VendedorRepository;
import com.gestionart.api.infrastructure.security.JwtService;

@Service
@Transactional
public class AutenticacionService {

    private final CompradorRepository compradorRepository;
    private final VendedorRepository vendedorRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AutenticacionService(
            CompradorRepository compradorRepository,
            VendedorRepository vendedorRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService) {

        this.compradorRepository = compradorRepository;
        this.vendedorRepository = vendedorRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
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

    @Transactional(readOnly = true)
    public String login(String correo, String contrasena) {

        Comprador comprador = compradorRepository
                .findByCorreoElectronico(correo)
                .orElse(null);

        if (comprador != null && contrasena.equals(comprador.getContrasena())) {
            return jwtService.generarToken(comprador.getCorreoElectronico(),"COMPRADOR");
        }

        Vendedor vendedor = vendedorRepository
                .findByCorreoElectronico(correo)
                .orElse(null);

        if (vendedor != null && contrasena.equals(vendedor.getContrasena())) {
            return jwtService.generarToken(vendedor.getCorreoElectronico(),"VENDEDOR");
        }
        throw new RuntimeException("Credenciales inválidas");
    }
}
