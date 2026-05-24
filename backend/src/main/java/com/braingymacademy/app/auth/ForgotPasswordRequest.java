package com.braingymacademy.app.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record ForgotPasswordRequest(
        @Email(message = "Enter a valid email")
        @NotBlank(message = "Email is required")
        String email
) {
}
