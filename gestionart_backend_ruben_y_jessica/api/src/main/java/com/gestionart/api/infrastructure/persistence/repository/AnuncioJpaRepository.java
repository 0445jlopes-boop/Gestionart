package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.domain.enums.Categoria;
import com.gestionart.api.infrastructure.persistence.entity.AnuncioEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AnuncioJpaRepository extends JpaRepository<AnuncioEntity, Long> {

    List<AnuncioEntity> findByVendedor_Id(Long id);

    List<AnuncioEntity> findByCategoria(Categoria categoria);
}