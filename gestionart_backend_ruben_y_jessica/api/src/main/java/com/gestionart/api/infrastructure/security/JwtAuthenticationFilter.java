package com.gestionart.api.infrastructure.security;

import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

import com.gestionart.api.infrastructure.persistence.entity.UsuarioEntity;
import com.gestionart.api.infrastructure.persistence.repository.UsuarioJpaRepository;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UsuarioJpaRepository usuarioJpaRepository;

    public JwtAuthenticationFilter(JwtService jwtService,
                                   UsuarioJpaRepository usuarioJpaRepository) {
        this.jwtService = jwtService;
        this.usuarioJpaRepository = usuarioJpaRepository;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String path = request.getRequestURI();

        // 🔓 Rutas públicas
        if (path.contains("/auth")) {
            filterChain.doFilter(request, response);
            return;
        }

        final String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        final String token = authHeader.substring(7);

        try {
            String email = jwtService.extractEmail(token);

            UsuarioEntity usuario = usuarioJpaRepository
                    .findByCorreoElectronico(email)
                    .orElse(null);

            if (usuario != null) {
                UsernamePasswordAuthenticationToken auth =
                        new UsernamePasswordAuthenticationToken(
                                usuario,
                                null,
                                new ArrayList<>()                        );

                SecurityContextHolder.getContext().setAuthentication(auth);
            }

        } catch (Exception e) {
            // opcional: log.error(e.getMessage());
        }

        filterChain.doFilter(request, response);
    }
}