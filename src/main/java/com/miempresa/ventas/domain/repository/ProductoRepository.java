package com.miempresa.ventas.domain.repository;

import com.miempresa.ventas.domain.model.Producto;
import com.miempresa.ventas.domain.valueobject.ProductoId;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Producto aggregate following DDD principles.
 * This interface belongs to the domain layer and defines the contract 
 * for persistence operations without implementation details.
 */
public interface ProductoRepository {
    
    /**
     * Saves a product (insert or update)
     */
    Producto save(Producto producto);
    
    /**
     * Finds a product by its ID
     */
    Optional<Producto> findById(ProductoId id);
    
    /**
     * Finds all products
     */
    List<Producto> findAll();
    
    /**
     * Finds products by name containing the specified text
     */
    List<Producto> findByNombreContaining(String nombre);
    
    /**
     * Finds products with stock greater than the specified amount
     */
    List<Producto> findByStockGreaterThan(int stock);
    
    /**
     * Deletes a product by its ID
     */
    void deleteById(ProductoId id);
    
    /**
     * Checks if a product exists by its ID
     */
    boolean existsById(ProductoId id);
}