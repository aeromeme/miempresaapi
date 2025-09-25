package com.miempresa.ventas.application.repository;

import com.miempresa.ventas.application.dto.TopProductoDTO;
import java.util.List;

public interface ProductoVentaRepository {
    List<TopProductoDTO> findTopProductosVendidos(int limit);
}