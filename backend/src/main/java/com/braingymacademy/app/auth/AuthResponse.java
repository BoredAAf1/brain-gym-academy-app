package com.braingymacademy.app.auth;

public record AuthResponse(
        Long id,
        String name,
        String email,
        UserRole role,
        String token,
        String message
) {
}
