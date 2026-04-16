package com.gestionart.api.application.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.TipoCuentaComprador;
import com.gestionart.api.domain.models.Comprador;
import com.gestionart.api.domain.models.Vendedor;
import com.gestionart.api.domain.repository.CompradorRepository;
import com.gestionart.api.domain.repository.VendedorRepository;
import com.gestionart.api.exception.ConflictBySecondaryId;
import com.gestionart.api.exception.InvalidCredentials;
import com.gestionart.api.exception.NotFoundByCorreoException;
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
            throw new ConflictBySecondaryId(comprador.getCorreoElectronico(), 1);
        }else if (compradorRepository.findByNombre(comprador.getNombre()).isPresent()) {
            throw new ConflictBySecondaryId(comprador.getNombre(), 2);
        }
        comprador.setContrasena(passwordEncoder.encode(comprador.getContrasena()));
        comprador.setTipoCuenta(TipoCuentaComprador.NORMAL);
        return compradorRepository.save(comprador);
    }

    public Vendedor registrarVendedor(Vendedor vendedor) {
        if (vendedorRepository.findByCorreoElectronico(vendedor.getCorreoElectronico()).isPresent()) {
            throw new ConflictBySecondaryId(vendedor.getCorreoElectronico(), 1);
        }else if (vendedorRepository.findByNombre(vendedor.getNombre()).isPresent()) {
            throw new ConflictBySecondaryId(vendedor.getNombre(), 2);
        }
        vendedor.setContrasena(passwordEncoder.encode(vendedor.getContrasena()));
        return vendedorRepository.save(vendedor);
    }

    @Transactional(readOnly = true)
    public String login(String correo, String contrasena) {

        Comprador comprador = compradorRepository
                .findByCorreoElectronico(correo)
                .orElseThrow(() -> new NotFoundByCorreoException(correo));

        if (comprador != null && contrasena.equals(comprador.getContrasena())) {
            return jwtService.generarToken(comprador.getCorreoElectronico(),"COMPRADOR");
        }

        Vendedor vendedor = vendedorRepository
                .findByCorreoElectronico(correo)
                .orElseThrow(() -> new NotFoundByCorreoException(correo));

        if (vendedor != null && contrasena.equals(vendedor.getContrasena())) {
            return jwtService.generarToken(vendedor.getCorreoElectronico(),"VENDEDOR");
        }
        throw new InvalidCredentials();
    }


}
