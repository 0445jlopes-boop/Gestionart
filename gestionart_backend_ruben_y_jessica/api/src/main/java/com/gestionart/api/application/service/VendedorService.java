package com.gestionart.api.application.service;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.models.Vendedor;
import com.gestionart.api.domain.repository.VendedorRepository;
import com.gestionart.api.exception.NotFoundByCorreoException;
import com.gestionart.api.exception.NotFoundByIdException;
import com.gestionart.api.exception.NotFoundByNombreException;

@Service
@Transactional
public class VendedorService {

    private final VendedorRepository vendedorRepository;
    private final PasswordEncoder passwordEncoder;

    public VendedorService(VendedorRepository vendedorRepository) {
        this.vendedorRepository = vendedorRepository;
        this.passwordEncoder = null;
    }

    public Vendedor obtenerPorId(Long id) {
        return vendedorRepository.findById(id).orElseThrow(() -> new NotFoundByIdException(id));
    }

    @Transactional(readOnly = true)
    public List<Vendedor> listarTodos() {
        return vendedorRepository.findAll();
    }

    public Vendedor obtenerPorCorreo(String correoElectronico) {
        return vendedorRepository.findByCorreoElectronico(correoElectronico).orElseThrow(() -> new NotFoundByCorreoException(correoElectronico));
    }

    public Vendedor obtenerPorNombre(String nombre) {
        return vendedorRepository.findByNombre(nombre).orElseThrow(() -> new NotFoundByNombreException(nombre));
    }


    public void eliminar(Long id) {
        vendedorRepository.deleteById(id);
    }

    public Vendedor actualizar(Long id, Vendedor datos) {
        Vendedor vendedor = obtenerPorId(id);

        if(datos.getNombre() != null) {
            vendedor.setNombre(datos.getNombre());
        }
        if(datos.getCorreoElectronico() != null) {
            vendedor.setCorreoElectronico(datos.getCorreoElectronico());
        }
        if(datos.getDescripcionPerfil() != null) {
            vendedor.setDescripcionPerfil(datos.getDescripcionPerfil());
        }
        if(datos.getImagen() != null) {
            vendedor.setImagen(datos.getImagen());
        }
        if(datos.getContrasena() != null) {
            vendedor.setContrasena(passwordEncoder.encode(datos.getContrasena()));
        }

        return vendedorRepository.save(vendedor);
    }

}