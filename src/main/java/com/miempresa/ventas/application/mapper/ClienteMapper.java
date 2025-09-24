package com.miempresa.ventas.application.mapper;

import com.miempresa.ventas.domain.model.Cliente;
import com.miempresa.ventas.application.dto.ClienteDto;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Mapper para convertir entre entidades de dominio y DTOs de aplicación.
 * Sigue principios DDD manteniendo la separación entre capas.
 */
public class ClienteMapper {
    
    /**
     * Convierte una entidad Cliente del dominio a DTO de aplicación
     */
    public static ClienteDto toDto(Cliente cliente) {
        if (cliente == null) {
            return null;
        }
        
        return new ClienteDto(
            cliente.getId().getValue().toString(), // El value object ClienteId se convierte a String
            cliente.getNombre(),
            cliente.getCorreo().getValor()
        );
    }
    
    /**
     * Convierte una lista de entidades Cliente a lista de DTOs
     */
    public static List<ClienteDto> toDto(List<Cliente> clientes) {
        if (clientes == null) {
            return List.of();
        }
        
        return clientes.stream()
            .map(ClienteMapper::toDto)
            .collect(Collectors.toList());
    }
    
    // Nota: No incluimos fromDto porque la creación de entidades
    // debe pasar por la lógica de negocio y validaciones del dominio
}