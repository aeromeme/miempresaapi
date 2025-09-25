package com.miempresa.ventas.application.repository;

import com.miempresa.ventas.application.dto.ClienteIngresosDTO;
import java.util.List;

public interface ClienteIngresosRepository {
    List<ClienteIngresosDTO> findClientesTopIngresos(int limit);
}