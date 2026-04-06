package com.gestionart.api.infrastructure.config;

import org.springframework.context.annotation.*;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import com.gestionart.api.infrastructure.security.JwtAuthenticationFilter;
@Configuration
public class SecurityConfig {

    private final JwtAuthenticationFilter filter;

    public SecurityConfig(JwtAuthenticationFilter filter) {
        this.filter = filter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http)
            throws Exception {

        http
            .csrf(csrf -> csrf.disable())

            // 🔥 SIN SESIONES (CLAVE PARA JWT)
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )

            .authorizeHttpRequests(auth -> auth

                // 🔓 LOGIN
                .requestMatchers("/auth/**").permitAll()

                // 🔓 REGISTRO
                .requestMatchers(HttpMethod.POST, "/compradores").permitAll()
                .requestMatchers(HttpMethod.POST, "/vendedores").permitAll()

                // 🔒 TODO LO DEMÁS
                .anyRequest().permitAll()
            )

            // 🔥 FILTRO JWT
            //.addFilterBefore(filter, UsernamePasswordAuthenticationFilter.class)

            // 🔥 DESACTIVAR LOGIN POR DEFECTO
            .httpBasic(httpBasic -> httpBasic.disable())
            .formLogin(form -> form.disable());

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    @Bean
    public org.springframework.security.core.userdetails.UserDetailsService userDetailsService() {
        return username -> null; // desactiva autenticación por defecto
    }
}

