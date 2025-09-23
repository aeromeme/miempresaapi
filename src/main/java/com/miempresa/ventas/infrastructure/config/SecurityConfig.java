package com.miempresa.ventas.infrastructure.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.context.annotation.Bean;

/**
 * Configuración temporal de Spring Security - DESHABILITADO para desarrollo.
 * 
 * IMPORTANTE: Esta configuración deshabilita completamente la seguridad.
 * Solo usar en desarrollo/testing. En producción configurar apropiadamente.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .anyRequest().permitAll()  // Permitir todas las requests sin autenticación
            )
            .csrf(csrf -> csrf.disable())  // Deshabilitar CSRF para APIs REST
            .formLogin(form -> form.disable())  // Deshabilitar form login
            .httpBasic(basic -> basic.disable());  // Deshabilitar HTTP Basic Auth
        
        return http.build();
    }
}