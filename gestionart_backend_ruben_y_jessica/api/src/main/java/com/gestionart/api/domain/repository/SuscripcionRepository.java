package com.gestionart.api.domain.repository;

import java.util.Optional;

import com.gestionart.api.domain.models.Suscripcion;

public interface SuscripcionRepository {

    Suscripcion save(Suscripcion suscripcion);

    Optional<Suscripcion> findById(Long id);

    Optional<Suscripcion> findByIdComprador(Long idComprador);

    void deleteById(Long id);
}