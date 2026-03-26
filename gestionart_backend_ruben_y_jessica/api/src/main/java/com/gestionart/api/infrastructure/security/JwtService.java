package com.gestionart.api.infrastructure.security;

import java.security.Key;
import java.util.Date;

import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtService { //Gestor de tokens

    private static final String SECRET_KEY ="mi_clave_super_segura_para_jwt_gestionart_2026";

    private final Key key = Keys.hmacShaKeyFor(SECRET_KEY.getBytes());

    public String generarToken(Long idUsuario, String rol) {

        return Jwts.builder()
                .setSubject(idUsuario.toString())
                .claim("rol", rol)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 86400000)) // 24h para expirarse
                .signWith(key)
                .compact();
    }

    public Claims extraerClaims(String token) { 

        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

}
