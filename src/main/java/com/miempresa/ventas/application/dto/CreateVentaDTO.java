
package com.miempresa.ventas.application.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import java.util.List;

/**
 * DTO para crear una nueva venta.
 * No incluye ID ya que será generado automáticamente.
 */
@Schema(description = "Datos para crear una nueva venta")
public class CreateVentaDTO {

    @NotBlank(message = "El ID del cliente es obligatorio")
    @Schema(description = "ID del cliente", example = "123", required = true)
    private String clienteId;

    @NotNull(message = "Las líneas de venta son obligatorias")
    @Size(min = 1, message = "Debe haber al menos una línea de venta")
    @Schema(description = "Lista de líneas de venta", required = true)
    private List<CreateLineaVentaDTO> lineasVenta;

    // Constructor por defecto para deserialización
    public CreateVentaDTO() {}

    public CreateVentaDTO(String clienteId, List<CreateLineaVentaDTO> lineasVenta) {
        this.clienteId = clienteId;
        this.lineasVenta = lineasVenta;
    }

    public String getClienteId() {
        return clienteId;
    }

    public void setClienteId(String clienteId) {
        this.clienteId = clienteId;
    }

    public List<CreateLineaVentaDTO> getLineasVenta() {
        return lineasVenta;
    }

    public void setLineasVenta(List<CreateLineaVentaDTO> lineasVenta) {
        this.lineasVenta = lineasVenta;
    }

    @Override
    public String toString() {
        return "CreateVentaDTO{" +
                "clienteId='" + clienteId + '\'' +
                ", lineasVenta=" + lineasVenta +
                '}';
    }
}
