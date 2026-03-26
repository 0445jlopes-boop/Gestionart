package com.gestionart.api.infrastructure.persistence.repository;

import com.gestionart.api.infrastructure.persistence.entity.ArticuloEntity;
import com.gestionart.api.domain.enums.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ArticuloJpaRepository extends JpaRepository<ArticuloEntity, Long> {

    List<ArticuloEntity> findByStockGreaterThan(int stock);

    List<ArticuloEntity> findByVendedor_Id(Long id);

    List<ArticuloEntity> findByCategoria(Categoria categoria);

    List<ArticuloEntity> findByVendedor_IdAndCategoria(Long id, Categoria categoria);
}
