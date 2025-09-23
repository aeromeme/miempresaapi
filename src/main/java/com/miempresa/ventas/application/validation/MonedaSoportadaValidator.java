package com.miempresa.ventas.application.validation;

import com.miempresa.ventas.domain.service.MonedaConfigurationService;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Validador personalizado para códigos de moneda.
 * Utiliza la configuración de monedas soportadas del sistema.
 */
public class MonedaSoportadaValidator implements ConstraintValidator<MonedaSoportada, String> {
    
    @Autowired
    private MonedaConfigurationService monedaConfigurationService;
    
    @Override
    public void initialize(MonedaSoportada constraintAnnotation) {
        // No hay inicialización específica necesaria
    }
    
    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        // null values are valid (usar @NotNull para validar obligatoriedad)
        if (value == null || value.trim().isEmpty()) {
            return true;
        }
        
        // Validar usando el servicio de configuración
        boolean isValid = monedaConfigurationService.isMonedaSoportada(value);
        
        if (!isValid) {
            // Personalizar el mensaje de error con las monedas soportadas
            String[] monedasSoportadas = monedaConfigurationService.getMonedasSoportadas();
            String mensaje = "Moneda no válida. Monedas soportadas: " + String.join(", ", monedasSoportadas);
            
            context.disableDefaultConstraintViolation();
            context.buildConstraintViolationWithTemplate(mensaje)
                   .addConstraintViolation();
        }
        
        return isValid;
    }
}