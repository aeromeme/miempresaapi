package com.miempresa.ventas.application.usecase;

import com.miempresa.ventas.application.dto.TopProductoDTO;
import com.miempresa.ventas.application.repository.ProductoVentaRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ObtenerTopProductosVendidosUseCase {

    private final ProductoVentaRepository productoVentaRepository;

    public ObtenerTopProductosVendidosUseCase(ProductoVentaRepository productoVentaRepository) {
        this.productoVentaRepository = productoVentaRepository;
    }

    private static final int LIMITE_TOP_PRODUCTOS = 3;

    public List<TopProductoDTO> ejecutar() {
        return productoVentaRepository.findTopProductosVendidos(LIMITE_TOP_PRODUCTOS);
    }
    public List<TopProductoDTO> ejecutar(Integer limit) {
        return productoVentaRepository.findTopProductosVendidos(limit);
    }
}