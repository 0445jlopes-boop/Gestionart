package com.gestionart.api.infrastructure.security;

import java.security.Key;
import java.util.Date;
import java.util.function.Function;

import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtService {

    private static final String SECRET_KEY =
            "mi_clave_super_segura_para_jwt_gestionart_2026";

    private final Key key = Keys.hmacShaKeyFor(SECRET_KEY.getBytes());

    // 🔐 GENERAR TOKEN (GUARDA EMAIL)
    public String generarToken(String email, String rol) {

        return Jwts.builder()
                .setSubject(email) // 👈 ahora guardamos EMAIL
                .claim("rol", rol)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 86400000))
                .signWith(key)
                .compact();
    }

    // 📦 EXTRAER CLAIMS
    public Claims extraerClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    // 🔧 MÉTODO GENÉRICO
    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extraerClaims(token);
        return claimsResolver.apply(claims);
    }

    // 👤 EXTRAER EMAIL
    public String extractEmail(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    // 🛡 VALIDAR TOKEN
    public boolean esTokenValido(String token) {
        try {
            Claims claims = extraerClaims(token);
            return !claims.getExpiration().before(new Date());
        } catch (Exception e) {
            return false;
        }
    }
}