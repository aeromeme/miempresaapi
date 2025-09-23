package com.miempresa.ventas.domain.exception;

/**
 * Base class for domain-specific business rule violations.
 * Represents exceptions that occur when business rules are violated.
 */
public class DomainException extends RuntimeException {
    
    public DomainException(String message) {
        super(message);
    }
    
    public DomainException(String message, Throwable cause) {
        super(message, cause);
    }
}