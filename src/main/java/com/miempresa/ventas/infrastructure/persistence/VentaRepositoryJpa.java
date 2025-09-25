package com.miempresa.ventas.infrastructure.persistence;

import com.miempresa.ventas.domain.model.Venta;
import com.miempresa.ventas.domain.valueobject.VentaId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VentaRepositoryJpa extends JpaRepository<Venta, VentaId> {
    // Puedes agregar métodos personalizados aquí si lo necesitas
}
