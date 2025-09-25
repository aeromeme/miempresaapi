package com.miempresa.ventas.infrastructure.web.controller;

import com.miempresa.ventas.application.dto.VentaDTO;
import com.miempresa.ventas.application.dto.UpdateVentaDTO;
import com.miempresa.ventas.application.dto.CreateVentaDTO;
import com.miempresa.ventas.application.service.VentaApplicationService;
import com.miempresa.ventas.domain.valueobject.Result;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/ventas")
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
    public ResponseEntity<VentaDTO> create(@RequestBody CreateVentaDTO createDto) {
        Result<VentaDTO> result = ventaApplicationService.create(createDto);
        if (result.isFailure() || result.getValue() == null) {
            return ResponseEntity.badRequest().body(null);
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

}
