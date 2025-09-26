package com.miempresa.ventas.application.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record VentaDTO(
    String id,
    ClienteDto cliente,
    LocalDateTime fechaVenta,
    BigDecimal total,
    String estado,
    List<LineaVentaDTO> lineasVenta
) {}
