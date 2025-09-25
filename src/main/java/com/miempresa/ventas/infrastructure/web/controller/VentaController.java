package com.miempresa.ventas.infrastructure.web.controller;

import com.miempresa.ventas.application.dto.VentaDTO;
import com.miempresa.ventas.application.mapper.VentaMapper;
import com.miempresa.ventas.domain.model.Venta;
import com.miempresa.ventas.domain.repository.VentaRepository;
import com.miempresa.ventas.domain.valueobject.VentaId;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/ventas")
public class VentaController {

    private final VentaRepository ventaRepository;
    private final VentaMapper ventaMapper;

    public VentaController(VentaRepository ventaRepository, VentaMapper ventaMapper) {
        this.ventaRepository = ventaRepository;
        this.ventaMapper = ventaMapper;
    }

    @GetMapping("/{id}")
    public ResponseEntity<VentaDTO> getById(@PathVariable String id) {
        VentaId ventaId = VentaId.from(id);
        Optional<Venta> ventaOpt = ventaRepository.findById(ventaId);
        if (ventaOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        VentaDTO dto = ventaMapper.toDto(ventaOpt.get());
        return ResponseEntity.ok(dto);
    }
}
