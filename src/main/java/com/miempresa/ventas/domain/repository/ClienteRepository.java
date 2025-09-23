package com.miempresa.ventas.domain.repository;

import com.miempresa.ventas.domain.model.Cliente;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.Email;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Cliente aggregate following DDD principles.
 * This interface belongs to the domain layer and defines the contract 
 * for persistence operations without implementation details.
 */
public interface ClienteRepository {
    
    /**
     * Saves a client (insert or update)
     */
    Cliente save(Cliente cliente);
    
    /**
     * Finds a client by its ID
     */
    Optional<Cliente> findById(ClienteId id);
    
    /**
     * Finds all clients
     */
    List<Cliente> findAll();
    
    /**
     * Finds clients with pagination
     */
    List<Cliente> findAll(int offset, int limit);
    
    /**
     * Counts total number of clients
     */
    long count();
    
    /**
     * Finds clients by name containing the specified text with pagination
     */
    List<Cliente> findByNombreContaining(String nombre, int offset, int limit);
    
    /**
     * Counts clients by name containing the specified text
     */
    long countByNombreContaining(String nombre);
    
    /**
     * Finds clients by email containing the specified text with pagination
     */
    List<Cliente> findByCorreoContaining(String correo, int offset, int limit);
    
    /**
     * Counts clients by email containing the specified text
     */
    long countByCorreoContaining(String correo);
    
    /**
     * Finds clients by name AND email containing the specified texts with pagination
     */
    List<Cliente> findByNombreContainingAndCorreoContaining(
        String nombre, String correo, int offset, int limit);
    
    /**
     * Counts clients by name AND email containing the specified texts
     */
    long countByNombreContainingAndCorreoContaining(String nombre, String correo);
    
    /**
     * Finds a client by email
     */
    Optional<Cliente> findByCorreo(Email correo);
    
    /**
     * Finds clients by name containing the specified text
     */
    List<Cliente> findByNombreContaining(String nombre);
    
    /**
     * Deletes a client by its ID
     */
    void deleteById(ClienteId id);
    
    /**
     * Checks if a client exists by its ID
     */
    boolean existsById(ClienteId id);
    
    /**
     * Checks if a client exists by email
     */
    boolean existsByCorreo(Email correo);
}