package com.miempresa.ventas.domain.repository;

import com.miempresa.ventas.domain.model.Venta;
import com.miempresa.ventas.domain.valueobject.VentaId;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Venta aggregate following DDD principles.
 * This interface belongs to the domain layer and defines the contract
 * for persistence operations without implementation details.
 */
public interface VentaRepository {
    /**
     * Finds sales by EstadoVenta
     */
    java.util.List<Venta> findByEstado(com.miempresa.ventas.domain.valueobject.EstadoVenta estado);

    /**
     * Saves a sale (insert or update)
     */
    Venta save(Venta venta);

    /**
     * Finds a sale by its ID
     */
    Optional<Venta> findById(VentaId id);

    /**
     * Finds all sales
     */
    List<Venta> findAll();

    /**
     * Finds sales by client ID
     */
    List<Venta> findByClienteId(ClienteId clienteId);

    /**
     * Finds sales between two dates
     */
    List<Venta> findByFechaBetween(LocalDateTime fechaInicio, LocalDateTime fechaFin);

    /**
     * Finds sales by client ID and date range
     */
    List<Venta> findByClienteIdAndFechaBetween(ClienteId clienteId, LocalDateTime fechaInicio, LocalDateTime fechaFin);

    /**
     * Deletes a sale by its ID
     */
    void deleteById(VentaId id);

    /**
     * Checks if a sale exists by its ID
     */
    boolean existsById(VentaId id);
}