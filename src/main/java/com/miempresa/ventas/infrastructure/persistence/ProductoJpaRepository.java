package com.miempresa.ventas.infrastructure.persistence;

import com.miempresa.ventas.domain.model.Producto;
import com.miempresa.ventas.domain.valueobject.ProductoId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * JPA Repository para la entidad Producto.
 * Esta interfaz pertenece a la capa de infraestructura y utiliza Spring Data JPA
 * para implementar automáticamente las operaciones de persistencia.
 */
@Repository
public interface ProductoJpaRepository extends JpaRepository<Producto, ProductoId> {
    
    /**
     * Busca productos por nombre (búsqueda parcial, insensible a mayúsculas)
     */
    @Query("SELECT p FROM Producto p WHERE LOWER(p.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))")
    List<Producto> findByNombreContainingIgnoreCase(@Param("nombre") String nombre);
    
    /**
     * Busca productos con stock mayor al especificado
     */
    @Query("SELECT p FROM Producto p WHERE p.stock > :stockMinimo")
    List<Producto> findByStockGreaterThan(@Param("stockMinimo") int stockMinimo);
    
    /**
     * Busca productos con stock menor o igual al especificado (productos con poco stock)
     */
    @Query("SELECT p FROM Producto p WHERE p.stock <= :stockMaximo")
    List<Producto> findByStockLessThanEqual(@Param("stockMaximo") int stockMaximo);
    
    /**
     * Busca productos en un rango de precios
     */
    @Query("SELECT p FROM Producto p WHERE p.precio.valor >= :precioMinimo AND p.precio.valor <= :precioMaximo")
    List<Producto> findByPrecioRange(
        @Param("precioMinimo") java.math.BigDecimal precioMinimo,
        @Param("precioMaximo") java.math.BigDecimal precioMaximo
    );
    
    /**
     * Cuenta productos con stock disponible (stock > 0)
     */
    @Query("SELECT COUNT(p) FROM Producto p WHERE p.stock > 0")
    long countProductosConStock();
    
    /**
     * Verifica si existe un producto con el nombre especificado (exacto, insensible a mayúsculas)
     */
    boolean existsByNombreIgnoreCase(String nombre);
}