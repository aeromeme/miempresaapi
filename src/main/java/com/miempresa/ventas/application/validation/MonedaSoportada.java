package com.miempresa.ventas.application.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

/**
 * Anotación de validación para verificar que un código de moneda esté soportado
 * por el sistema según la configuración.
 */
@Documented
@Constraint(validatedBy = MonedaSoportadaValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface MonedaSoportada {
    
    String message() default "Código de moneda no soportado";
    
    Class<?>[] groups() default {};
    
    Class<? extends Payload>[] payload() default {};
}