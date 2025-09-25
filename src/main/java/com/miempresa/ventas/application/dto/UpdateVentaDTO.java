
package com.miempresa.ventas.application.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import java.util.List;

/**
 * DTO para actualizar una venta.
 */
@Schema(description = "Datos para actualizar una venta")
public class UpdateVentaDTO {

    @NotBlank(message = "El ID de la venta es obligatorio")
    @Schema(description = "ID de la venta", example = "1", required = true)
    private String id;

    @NotBlank(message = "El ID del cliente es obligatorio")
    @Schema(description = "ID del cliente", example = "123", required = true)
    private String clienteId;

    @NotNull(message = "Las líneas de venta son obligatorias")
    @Size(min = 1, message = "Debe haber al menos una línea de venta")
    @Schema(description = "Lista de líneas de venta", required = true)
    private List<UpdateLineaVentaDTO> lineasVenta;

    // Constructor por defecto para deserialización
    public UpdateVentaDTO() {}

    public UpdateVentaDTO(String id, String clienteId, List<UpdateLineaVentaDTO> lineasVenta) {
        this.id = id;
        this.clienteId = clienteId;
        this.lineasVenta = lineasVenta;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getClienteId() {
        return clienteId;
    }

    public void setClienteId(String clienteId) {
        this.clienteId = clienteId;
    }

    public List<UpdateLineaVentaDTO> getLineasVenta() {
        return lineasVenta;
    }

    public void setLineasVenta(List<UpdateLineaVentaDTO> lineasVenta) {
        this.lineasVenta = lineasVenta;
    }

    @Override
    public String toString() {
        return "UpdateVentaDTO{" +
                "id='" + id + '\'' +
                ", clienteId='" + clienteId + '\'' +
                ", lineasVenta=" + lineasVenta +
                '}';
    }
}
