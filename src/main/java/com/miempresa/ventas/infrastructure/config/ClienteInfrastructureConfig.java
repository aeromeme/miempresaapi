package com.miempresa.ventas.infrastructure.config;

import com.miempresa.ventas.domain.repository.ClienteRepository;
import com.miempresa.ventas.infrastructure.repository.ClienteRepositoryImpl;
import com.miempresa.ventas.infrastructure.persistence.ClienteJpaRepository;
import com.miempresa.ventas.application.service.ClienteApplicationService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuración de Spring para la capa de infraestructura de Cliente.
 * Esta clase define los beans necesarios para inyección de dependencias
 * y conecta las capas de dominio, aplicación e infraestructura.
 */
@Configuration
public class ClienteInfrastructureConfig {
    
    /**
     * Bean para el repositorio de Cliente
     */
    @Bean
    public ClienteRepository clienteRepository(ClienteJpaRepository clienteJpaRepository) {
        return new ClienteRepositoryImpl(clienteJpaRepository);
    }
    
    /**
     * Bean para el servicio de aplicación de Cliente
     */
    @Bean
    public ClienteApplicationService clienteApplicationService(ClienteRepository clienteRepository) {
        return new ClienteApplicationService(clienteRepository);
    }
}