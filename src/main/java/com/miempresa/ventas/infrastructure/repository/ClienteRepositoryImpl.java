package com.miempresa.ventas.infrastructure.repository;

import com.miempresa.ventas.domain.model.Cliente;
import com.miempresa.ventas.domain.repository.ClienteRepository;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.Email;
import com.miempresa.ventas.infrastructure.persistence.ClienteJpaRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Implementación del repositorio de Cliente usando Spring Data JPA.
 * Esta clase pertenece a la capa de infraestructura y actúa como adaptador
 * entre el dominio y la persistencia JPA.
 */
@Component
public class ClienteRepositoryImpl implements ClienteRepository {
    
    private final ClienteJpaRepository clienteJpaRepository;
    
    public ClienteRepositoryImpl(ClienteJpaRepository clienteJpaRepository) {
        this.clienteJpaRepository = clienteJpaRepository;
    }
    
    @Override
    public Cliente save(Cliente cliente) {
        return clienteJpaRepository.save(cliente);
    }
    
    @Override
    public Optional<Cliente> findById(ClienteId id) {
        UUID uuid = id.getValue();
        return clienteJpaRepository.findById(uuid);
    }
    
    @Override
    public List<Cliente> findAll() {
        return clienteJpaRepository.findAll();
    }
    
    @Override
    public List<Cliente> findAll(int offset, int limit) {
        return clienteJpaRepository.findAllWithOffsetAndLimit(offset, limit);
    }
    
    @Override
    public long count() {
        return clienteJpaRepository.count();
    }
    
    @Override
    public List<Cliente> findByNombreContaining(String nombre, int offset, int limit) {
        return clienteJpaRepository.findByNombreContainingWithOffsetAndLimit(nombre, offset, limit);
    }
    
    @Override
    public long countByNombreContaining(String nombre) {
        return clienteJpaRepository.countByNombreContainingIgnoreCase(nombre);
    }
    
    @Override
    public List<Cliente> findByCorreoContaining(String correo, int offset, int limit) {
        return clienteJpaRepository.findByCorreoContainingWithOffsetAndLimit(correo, offset, limit);
    }
    
    @Override
    public long countByCorreoContaining(String correo) {
        return clienteJpaRepository.countByCorreoContainingIgnoreCase(correo);
    }
    
    @Override
    public List<Cliente> findByNombreContainingAndCorreoContaining(
            String nombre, String correo, int offset, int limit) {
        return clienteJpaRepository.findByNombreContainingAndCorreoContainingWithOffsetAndLimit(
            nombre, correo, offset, limit);
    }
    
    @Override
    public long countByNombreContainingAndCorreoContaining(String nombre, String correo) {
        return clienteJpaRepository.countByNombreContainingAndCorreoContainingIgnoreCase(nombre, correo);
    }
    
    @Override
    public Optional<Cliente> findByCorreo(Email correo) {
        return clienteJpaRepository.findByCorreo(correo.getValor());
    }
    
    @Override
    public List<Cliente> findByNombreContaining(String nombre) {
        return clienteJpaRepository.findByNombreContainingIgnoreCase(nombre);
    }
    
    @Override
    public void deleteById(ClienteId id) {
        UUID uuid = id.getValue();
        clienteJpaRepository.deleteById(uuid);
    }
    
    @Override
    public boolean existsById(ClienteId id) {
        UUID uuid = id.getValue();
        return clienteJpaRepository.existsById(uuid);
    }
    
    @Override
    public boolean existsByCorreo(Email correo) {
        return clienteJpaRepository.existsByCorreo(correo.getValor());
    }
}