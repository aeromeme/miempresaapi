package com.miempresa.ventas.domain.service;

import com.miempresa.ventas.domain.valueobject.Moneda;

/**
 * Servicio de dominio para configuración de monedas.
 * Define las operaciones relacionadas con la configuración de monedas
 * sin depender de detalles de infraestructura.
 */
public interface MonedaConfigurationService {
    
    /**
     * Obtiene la moneda por defecto configurada para el sistema.
     * 
     * @return la moneda por defecto
     */
    Moneda getMonedaPorDefecto();
    
    /**
     * Verifica si una moneda está soportada por el sistema.
     * 
     * @param codigoMoneda el código de la moneda a verificar
     * @return true si la moneda está soportada, false si no
     */
    boolean isMonedaSoportada(String codigoMoneda);
    
    /**
     * Obtiene la lista de códigos de monedas soportadas.
     * 
     * @return array con los códigos de monedas soportadas
     */
    String[] getMonedasSoportadas();
}