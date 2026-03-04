package com.gestionart.api.application.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gestionart.api.domain.models.Vendedor;
import com.gestionart.api.domain.repository.VendedorRepository;

@Service
@Transactional
public class VendedorService {

    private final VendedorRepository vendedorRepository;

    public VendedorService(VendedorRepository vendedorRepository) {
        this.vendedorRepository = vendedorRepository;
    }

    /*
     * Obtener vendedor por ID
     */
    @Transactional(readOnly = true)
    public Vendedor obtenerPorId(Long id) {
        return vendedorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vendedor no encontrado"));
    }

    /*
     * Listar todos los vendedores
     */
    @Transactional(readOnly = true)
    public List<Vendedor> listarTodos() {
        return vendedorRepository.findAll();
    }

    /*
     * Obtener por correo (útil para autenticación o validación)
     */
    @Transactional(readOnly = true)
    public Vendedor obtenerPorCorreo(String correo) {
        return vendedorRepository.findByCorreoElectronico(correo)
                .orElseThrow(() -> new RuntimeException("Vendedor no encontrado"));
    }

    /*
     * Actualizar perfil del vendedor
     */
    public Vendedor actualizarPerfil(Long id, Vendedor datos) {

        Vendedor vendedor = obtenerPorId(id);

        vendedor.setNombre(datos.getNombre());
        vendedor.setDescripcionPerfil(datos.getDescripcionPerfil());
        vendedor.setImagen(datos.getImagen());

        return vendedorRepository.save(vendedor);
    }


    public void eliminar(Long id) {
        vendedorRepository.deleteById(id);
    }

}