package com.miempresa.ventas.infrastructure.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Propiedades de configuración para monedas.
 * Permite configurar la moneda por defecto y las monedas soportadas
 * a través de application.properties.
 */
@Component
@ConfigurationProperties(prefix = "ventas.moneda")
public class MonedaConfigurationProperties {
    
    /**
     * Código de la moneda por defecto del sistema.
     * Por defecto: USD
     */
    private String porDefecto = "USD";
    
    /**
     * Lista de códigos de monedas soportadas por el sistema.
     * Por defecto: Monedas de Centroamérica y USD
     */
    private List<String> soportadas = List.of(
        "USD", // Estados Unidos - Dólar
        "GTQ", // Guatemala - Quetzal
        "BZD", // Belice - Dólar de Belice
        "HNL", // Honduras - Lempira
        "NIO", // Nicaragua - Córdoba
        "CRC", // Costa Rica - Colón
        "PAB"  // Panamá - Balboa
    );
    
    // Getters y Setters
    public String getPorDefecto() {
        return porDefecto;
    }
    
    public void setPorDefecto(String porDefecto) {
        this.porDefecto = porDefecto;
    }
    
    public List<String> getSoportadas() {
        return soportadas;
    }
    
    public void setSoportadas(List<String> soportadas) {
        this.soportadas = soportadas;
    }
    
    @Override
    public String toString() {
        return "MonedaConfigurationProperties{" +
                "porDefecto='" + porDefecto + '\'' +
                ", soportadas=" + soportadas +
                '}';
    }
}