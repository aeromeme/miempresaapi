package com.miempresa.ventas.infrastructure.persistence;

import com.miempresa.ventas.domain.model.Cliente;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * JPA Repository para la entidad Cliente.
 * Esta interfaz pertenece a la capa de infraestructura y utiliza Spring Data JPA
 * para implementar automáticamente las operaciones de persistencia.
 */
@Repository
public interface ClienteJpaRepository extends JpaRepository<Cliente, ClienteId> {
    
    /**
     * Busca un cliente por su correo electrónico
     */
    Optional<Cliente> findByCorreo(String correo);
    
    /**
     * Verifica si existe un cliente con el correo especificado
     */
    boolean existsByCorreo(String correo);
    
    /**
     * Busca clientes cuyo nombre contenga el texto especificado (case insensitive)
     */
    @Query("SELECT c FROM Cliente c WHERE LOWER(c.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))")
    List<Cliente> findByNombreContainingIgnoreCase(@Param("nombre") String nombre);
    
    /**
     * Busca clientes cuyo correo contenga el texto especificado (case insensitive)
     */
    @Query("SELECT c FROM Cliente c WHERE LOWER(c.correo) LIKE LOWER(CONCAT('%', :correo, '%'))")
    List<Cliente> findByCorreoContainingIgnoreCase(@Param("correo") String correo);
    
    /**
     * Busca clientes cuyo nombre Y correo contengan los textos especificados (case insensitive)
     */
    @Query("SELECT c FROM Cliente c WHERE LOWER(c.nombre) LIKE LOWER(CONCAT('%', :nombre, '%')) " +
           "AND LOWER(c.correo) LIKE LOWER(CONCAT('%', :correo, '%'))")
    List<Cliente> findByNombreContainingAndCorreoContainingIgnoreCase(
        @Param("nombre") String nombre, 
        @Param("correo") String correo
    );
    
    /**
     * Busca clientes con paginación manual usando OFFSET y LIMIT
     */
    @Query(value = "SELECT * FROM clientes ORDER BY nombre ASC LIMIT :limit OFFSET :offset", 
           nativeQuery = true)
    List<Cliente> findAllWithOffsetAndLimit(@Param("offset") int offset, @Param("limit") int limit);
    
    /**
     * Busca clientes por nombre con paginación manual
     */
    @Query(value = "SELECT * FROM clientes WHERE LOWER(nombre) LIKE LOWER(CONCAT('%', :nombre, '%')) " +
                   "ORDER BY nombre ASC LIMIT :limit OFFSET :offset", 
           nativeQuery = true)
    List<Cliente> findByNombreContainingWithOffsetAndLimit(
        @Param("nombre") String nombre, 
        @Param("offset") int offset, 
        @Param("limit") int limit
    );
    
    /**
     * Busca clientes por correo con paginación manual
     */
    @Query(value = "SELECT * FROM clientes WHERE LOWER(correo) LIKE LOWER(CONCAT('%', :correo, '%')) " +
                   "ORDER BY nombre ASC LIMIT :limit OFFSET :offset", 
           nativeQuery = true)
    List<Cliente> findByCorreoContainingWithOffsetAndLimit(
        @Param("correo") String correo, 
        @Param("offset") int offset, 
        @Param("limit") int limit
    );
    
    /**
     * Busca clientes por nombre Y correo con paginación manual
     */
    @Query(value = "SELECT * FROM clientes WHERE LOWER(nombre) LIKE LOWER(CONCAT('%', :nombre, '%')) " +
                   "AND LOWER(correo) LIKE LOWER(CONCAT('%', :correo, '%')) " +
                   "ORDER BY nombre ASC LIMIT :limit OFFSET :offset", 
           nativeQuery = true)
    List<Cliente> findByNombreContainingAndCorreoContainingWithOffsetAndLimit(
        @Param("nombre") String nombre, 
        @Param("correo") String correo, 
        @Param("offset") int offset, 
        @Param("limit") int limit
    );
    
    /**
     * Cuenta clientes cuyo nombre contenga el texto especificado
     */
    @Query("SELECT COUNT(c) FROM Cliente c WHERE LOWER(c.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))")
    long countByNombreContainingIgnoreCase(@Param("nombre") String nombre);
    
    /**
     * Cuenta clientes cuyo correo contenga el texto especificado
     */
    @Query("SELECT COUNT(c) FROM Cliente c WHERE LOWER(c.correo) LIKE LOWER(CONCAT('%', :correo, '%'))")
    long countByCorreoContainingIgnoreCase(@Param("correo") String correo);
    
    /**
     * Cuenta clientes cuyo nombre Y correo contengan los textos especificados
     */
    @Query("SELECT COUNT(c) FROM Cliente c WHERE LOWER(c.nombre) LIKE LOWER(CONCAT('%', :nombre, '%')) " +
           "AND LOWER(c.correo) LIKE LOWER(CONCAT('%', :correo, '%'))")
    long countByNombreContainingAndCorreoContainingIgnoreCase(
        @Param("nombre") String nombre, 
        @Param("correo") String correo
    );
}