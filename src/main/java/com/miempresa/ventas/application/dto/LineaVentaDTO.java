package com.miempresa.ventas.application.dto;

import java.math.BigDecimal;

public record LineaVentaDTO(
    String productoId,
    Integer cantidad,
    BigDecimal precioUnitario,
    BigDecimal subtotal
) {}
