package com.miempresa.ventas.application.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record ClienteIngresosDTO(
    UUID id,
    String nombre,
    String correo,
    Long totalVentas,
    BigDecimal totalIngresos
) {}