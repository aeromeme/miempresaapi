package com.miempresa.ventas.infrastructure.repository;

import com.miempresa.ventas.domain.model.Producto;
import com.miempresa.ventas.domain.repository.ProductoRepository;
import com.miempresa.ventas.domain.valueobject.ProductoId;
import com.miempresa.ventas.infrastructure.persistence.ProductoJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

/**
 * Implementación del repositorio de Producto usando Spring Data JPA.
 * Esta clase pertenece a la capa de infraestructura y actúa como adaptador
 * entre el dominio y la persistencia JPA.
 */
@Component
public class ProductoRepositoryImpl implements ProductoRepository {
    
    private final ProductoJpaRepository productoJpaRepository;
    
    public ProductoRepositoryImpl(ProductoJpaRepository productoJpaRepository) {
        this.productoJpaRepository = productoJpaRepository;
    }
    
    @Override
    public Producto save(Producto producto) {
        return productoJpaRepository.save(producto);
    }
    
    @Override
    public Optional<Producto> findById(ProductoId id) {
        return productoJpaRepository.findById(id);
    }
    
    @Override
    public List<Producto> findAll() {
        return productoJpaRepository.findAll();
    }
    
    @Override
    public void deleteById(ProductoId id) {
        productoJpaRepository.deleteById(id);
    }
    
    @Override
    public boolean existsById(ProductoId id) {
        return productoJpaRepository.existsById(id);
    }
    
    @Override
    public List<Producto> findByNombreContaining(String nombre) {
        return productoJpaRepository.findByNombreContainingIgnoreCase(nombre);
    }
    
    @Override
    public List<Producto> findByStockGreaterThan(int stock) {
        return productoJpaRepository.findByStockGreaterThan(stock);
    }
}