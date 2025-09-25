package com.miempresa.ventas.application.usecase;

import com.miempresa.ventas.application.dto.ClienteIngresosDTO;
import com.miempresa.ventas.application.repository.ClienteIngresosRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ObtenerClientesTopIngresosUseCase {
    
    private static final int LIMITE_TOP_CLIENTES = 1;
    private final ClienteIngresosRepository clienteIngresosRepository;

    public ObtenerClientesTopIngresosUseCase(ClienteIngresosRepository clienteIngresosRepository) {
        this.clienteIngresosRepository = clienteIngresosRepository;
    }

    public List<ClienteIngresosDTO> ejecutar() {
        return clienteIngresosRepository.findClientesTopIngresos(LIMITE_TOP_CLIENTES);
    }
    public List<ClienteIngresosDTO> ejecutar(Integer limit) {
        return clienteIngresosRepository.findClientesTopIngresos(limit);
    }
}