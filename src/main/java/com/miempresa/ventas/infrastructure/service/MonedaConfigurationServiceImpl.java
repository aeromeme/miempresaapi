package com.miempresa.ventas.infrastructure.service;

import com.miempresa.ventas.domain.service.MonedaConfigurationService;
import com.miempresa.ventas.domain.valueobject.Moneda;
import com.miempresa.ventas.infrastructure.config.properties.MonedaConfigurationProperties;
import org.springframework.stereotype.Service;

/**
 * Implementación del servicio de configuración de monedas.
 * Utiliza las propiedades de configuración de Spring Boot.
 */
@Service
public class MonedaConfigurationServiceImpl implements MonedaConfigurationService {
    
    private final MonedaConfigurationProperties properties;
    
    public MonedaConfigurationServiceImpl(MonedaConfigurationProperties properties) {
        this.properties = properties;
    }
    
    @Override
    public Moneda getMonedaPorDefecto() {
        return Moneda.of(properties.getPorDefecto());
    }
    
    @Override
    public boolean isMonedaSoportada(String codigoMoneda) {
        if (codigoMoneda == null || codigoMoneda.trim().isEmpty()) {
            return false;
        }
        return properties.getSoportadas().contains(codigoMoneda.toUpperCase());
    }
    
    @Override
    public String[] getMonedasSoportadas() {
        return properties.getSoportadas().toArray(new String[0]);
    }
}