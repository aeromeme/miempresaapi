package com.miempresa.ventas.infrastructure.repository;

import com.miempresa.ventas.domain.model.Venta;
import com.miempresa.ventas.domain.repository.VentaRepository;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.EstadoVenta;
import com.miempresa.ventas.domain.valueobject.VentaId;
import com.miempresa.ventas.infrastructure.persistence.VentaRepositoryJpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class VentaRepositoryImpl implements VentaRepository {
    @Override
    public List<Venta> findByEstado(EstadoVenta estado) {
        return ventaRepositoryJpa.findByEstado(estado);
    }

    private final VentaRepositoryJpa ventaRepositoryJpa;

    @Autowired
    public VentaRepositoryImpl(VentaRepositoryJpa ventaRepositoryJpa) {
        this.ventaRepositoryJpa = ventaRepositoryJpa;
    }

    @Override
    public Venta save(Venta venta) {
        return ventaRepositoryJpa.save(venta);
    }

    @Override
    public Optional<Venta> findById(VentaId id) {
        return ventaRepositoryJpa.findById(id);
    }

    @Override
    public List<Venta> findAll() {
        return ventaRepositoryJpa.findAll();
    }

    @Override
    public void deleteById(VentaId id) {
        ventaRepositoryJpa.deleteById(id);
    }

    @Override
    public List<Venta> findByClienteId(ClienteId clienteId) {
        // Si VentaRepositoryJpa tiene el método, úsalo directamente:
        // return ventaRepositoryJpa.findByClienteId(clienteId);

        // Alternativamente, filtrar manualmente:
        return ventaRepositoryJpa.findAll().stream()
                .filter(v -> v.getCliente() != null && v.getCliente().getId().equals(clienteId))
                .toList();
    }

    @Override
    public List<Venta> findByFechaBetween(LocalDateTime fechaInicio, LocalDateTime fechaFin) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'findByFechaBetween'");
    }

    @Override
    public List<Venta> findByClienteIdAndFechaBetween(ClienteId clienteId, LocalDateTime fechaInicio,
            LocalDateTime fechaFin) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'findByClienteIdAndFechaBetween'");
    }

    @Override
    public boolean existsById(VentaId id) {
        return ventaRepositoryJpa.existsById(id);
    }
}
