package com.miempresa.ventas.domain.valueobject;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import java.math.BigDecimal;

@Embeddable
public class Precio extends ValueObject {
    @Column(name = "precio_valor", nullable = false, precision = 19, scale = 2)
    private BigDecimal valor;
    
    // Constructor para JPA
    protected Precio() {
        // Constructor requerido por JPA
    }
    
    public Precio(BigDecimal valor) {
        if (valor == null) {
            throw new IllegalArgumentException("El precio no puede ser null");
        }
        if (valor.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("El precio no puede ser negativo");
        }
        this.valor = valor;
    }
    
    public static Precio of(double valor) {
        return new Precio(BigDecimal.valueOf(valor));
    }
    
    public static Precio of(BigDecimal valor) {
        return new Precio(valor);
    }
    
    public BigDecimal getValor() {
        return valor;
    }
    
    public Precio multiplicar(int cantidad) {
        return new Precio(valor.multiply(BigDecimal.valueOf(cantidad)));
    }
    
    public Precio sumar(Precio otroPrecio) {
        return new Precio(valor.add(otroPrecio.valor));
    }
    
    public Precio restar(Precio otroPrecio) {
        BigDecimal resultado = valor.subtract(otroPrecio.valor);
        if (resultado.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("El resultado de la resta no puede ser negativo");
        }
        return new Precio(resultado);
    }
    
    public boolean esMayorQue(Precio otroPrecio) {
        return this.valor.compareTo(otroPrecio.valor) > 0;
    }
    
    public boolean esMenorQue(Precio otroPrecio) {
        return this.valor.compareTo(otroPrecio.valor) < 0;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Precio)) return false;
        Precio that = (Precio) obj;
        return areEqual(this.valor, that.valor);
    }
    
    @Override
    public int hashCode() {
        return hashOf(valor);
    }
    
    @Override
    public String toString() {
        return valor.toString();
    }
}