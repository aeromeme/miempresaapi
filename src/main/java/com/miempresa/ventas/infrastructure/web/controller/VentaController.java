package com.miempresa.ventas.infrastructure.web.controller;

import com.miempresa.ventas.application.dto.VentaDTO;
import com.miempresa.ventas.application.dto.UpdateVentaDTO;
import com.miempresa.ventas.application.dto.CreateVentaDTO;
import com.miempresa.ventas.application.dto.ProductoDto;
import com.miempresa.ventas.application.service.VentaApplicationService;
import com.miempresa.ventas.domain.valueobject.Result;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ventas")
@Tag(name = "Ventas", description = "API para gestión de ventas")
public class VentaController {

    private final VentaApplicationService ventaApplicationService;

    public VentaController(VentaApplicationService ventaApplicationService) {
        this.ventaApplicationService = ventaApplicationService;
    }

    @PutMapping("/{id}")
    public ResponseEntity<VentaDTO> update(@PathVariable String id, @RequestBody UpdateVentaDTO updateDto) {
        updateDto.setId(id);
        Result<VentaDTO> result = ventaApplicationService.update(id, updateDto);
        if (result.isFailure()) {
            return ResponseEntity.badRequest().body(null);
        }
        return ResponseEntity.ok(result.getValue());
    }

    @PostMapping
    @Operation(summary = "Crear nuevo producto", description = "Crea un nuevo producto en el sistema")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Producto creado exitosamente", content = @Content(schema = @Schema(implementation = VentaDTO.class))),
            @ApiResponse(responseCode = "400", description = "Datos de entrada inválidos", content = @Content(schema = @Schema(implementation = ProblemDetail.class)))
    })
    public ResponseEntity<?> create(@RequestBody CreateVentaDTO createDto) {
        Result<VentaDTO> result = ventaApplicationService.create(createDto);
        if (result.isFailure() || result.getValue() == null) {
            return ResponseEntity.badRequest().body(ProblemDetail.forStatusAndDetail(
                    HttpStatus.BAD_REQUEST,
                    "Error al crear la venta: " + result.getFirstError()));
        }
        return ResponseEntity.ok(result.getValue());
    }

    @GetMapping("/{id}")
    public ResponseEntity<VentaDTO> getById(@PathVariable String id) {
        var result = ventaApplicationService.findById(id);
        if (result.isFailure() || result.getValue() == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(result.getValue());
    }

    @GetMapping
    public ResponseEntity<java.util.List<VentaDTO>> getAll() {
        var result = ventaApplicationService.findAll();
        if (result.isFailure() || result.getValue() == null) {
            return ResponseEntity.badRequest().body(null);
        }
        return ResponseEntity.ok(result.getValue());
    }

    @GetMapping("/cliente/{clienteId}")
    public ResponseEntity<java.util.List<VentaDTO>> getByClienteId(@PathVariable String clienteId) {
        var result = ventaApplicationService.findByClienteId(clienteId);
        if (result.isFailure() || result.getValue() == null) {
            return ResponseEntity.badRequest().body(null);
        }
        return ResponseEntity.ok(result.getValue());
    }

    @GetMapping("/estado/{estado}")
    public ResponseEntity<java.util.List<VentaDTO>> getByEstado(@PathVariable String estado) {
        var result = ventaApplicationService.findByEstado(estado);
        if (result.isFailure() || result.getValue() == null) {
            return ResponseEntity.badRequest().body(null);
        }
        return ResponseEntity.ok(result.getValue());
    }

}
