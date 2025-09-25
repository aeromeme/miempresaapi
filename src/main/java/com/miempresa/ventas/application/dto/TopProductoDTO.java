package com.miempresa.ventas.application.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record TopProductoDTO(
    UUID id,
    String nombre,
    Long totalVendido,
    BigDecimal totalIngresos
) {}