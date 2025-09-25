package com.miempresa.ventas.application.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record IngresosMensualesDTO(
    LocalDateTime periodo,
    Integer anio,
    Integer mes,
    Long totalVentas,
    Long totalClientes,
    BigDecimal ingresoTotal
) {}