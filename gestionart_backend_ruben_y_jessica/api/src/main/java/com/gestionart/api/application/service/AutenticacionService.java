package com.gestionart.api.application.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.enums.Rol;
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
        if (compradorRepository.findByCorreoElectronico(comprador.getCorreoElectronico()).isPresent() || vendedorRepository.findByCorreoElectronico(comprador.getCorreoElectronico()).isPresent()) {
            throw new ConflictBySecondaryId(comprador.getCorreoElectronico(), 1);
        }else if (compradorRepository.findByNombre(comprador.getNombre()).isPresent() || vendedorRepository.findByNombre(comprador.getNombre()).isPresent()) {
            throw new ConflictBySecondaryId(comprador.getNombre(), 2);
        }
       comprador.setContrasena(passwordEncoder.encode(comprador.getContrasena()));
         /*comprador.setRol(Rol.COMPRADOR);
        comprador.setTipoCuenta(TipoCuentaComprador.NORMAL);
        comprador.setFechaInicioPremium(null);
        comprador.setFechaFinPremium(null); */
        return compradorRepository.save(comprador);
    }

    public Vendedor registrarVendedor(Vendedor vendedor) {
        if (vendedorRepository.findByCorreoElectronico(vendedor.getCorreoElectronico()).isPresent() || compradorRepository.findByCorreoElectronico(vendedor.getCorreoElectronico()).isPresent()) {
            throw new ConflictBySecondaryId(vendedor.getCorreoElectronico(), 1);
        }else if (vendedorRepository.findByNombre(vendedor.getNombre()).isPresent() || compradorRepository.findByNombre(vendedor.getNombre()).isPresent()) {
            throw new ConflictBySecondaryId(vendedor.getNombre(), 2);
        }
        vendedor.setContrasena(passwordEncoder.encode(vendedor.getContrasena()));
        /*vendedor.setRol(Rol.VENDEDOR);
        vendedor.setDescripcionPerfil(vendedor.getDescripcionPerfil() != null ? vendedor.getDescripcionPerfil() : "");
        vendedor.setImagen(vendedor.getImagen() != null ? vendedor.getImagen() : "");
        */
        return vendedorRepository.save(vendedor);
    }

    @Transactional(readOnly = true)
    public String login(String correo, String contrasena) {

        // Buscar en Compradores
        var compradorOpt = compradorRepository.findByCorreoElectronico(correo);
        if (compradorOpt.isPresent()) {
            Comprador comprador = compradorOpt.get();
            if (passwordEncoder.matches(contrasena, comprador.getContrasena())) {
                return jwtService.generarToken(comprador.getCorreoElectronico(), "COMPRADOR");
            }
            // Si existe pero contraseña incorrecta
            throw new InvalidCredentials();
        }

        // Buscar en Vendedores
        var vendedorOpt = vendedorRepository.findByCorreoElectronico(correo);
        if (vendedorOpt.isPresent()) {
            Vendedor vendedor = vendedorOpt.get();
            if (passwordEncoder.matches(contrasena, vendedor.getContrasena())) {
                return jwtService.generarToken(vendedor.getCorreoElectronico(), "VENDEDOR");
            }
            // Si existe pero contraseña incorrecta
            throw new InvalidCredentials();
        }

        // Usuario no encontrado en ninguna tabla
        throw new NotFoundByCorreoException(correo);
    }


}
