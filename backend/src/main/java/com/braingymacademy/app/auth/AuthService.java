package com.braingymacademy.app.auth;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Random;

@Service
public class AuthService {

    private static final String ADMIN_EMAIL = "mohnishpathak.2011@gmail.com";

    private final ParentUserRepository parentUserRepository;
    private final JwtService jwtService;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public AuthService(ParentUserRepository parentUserRepository, JwtService jwtService, EmailService emailService) {
        this.parentUserRepository = parentUserRepository;
        this.jwtService = jwtService;
        this.emailService = emailService;
    }

    public AuthResponse register(RegisterRequest request) {
        String email = request.email().trim().toLowerCase();
        if (parentUserRepository.existsByEmailIgnoreCase(email)) {
            throw new AuthException("An account with this email already exists.");
        }

        ParentUser savedUser = parentUserRepository.save(
                new ParentUser(
                        request.name().trim(),
                        email,
                        passwordEncoder.encode(request.password())
                )
        );
        applyReservedAdminRole(savedUser);

        return new AuthResponse(
                savedUser.getId(),
                savedUser.getName(),
                savedUser.getEmail(),
                savedUser.getRole(),
                jwtService.createToken(savedUser),
                "Account created successfully."
        );
    }

    public AuthResponse login(LoginRequest request) {
        ParentUser user = parentUserRepository.findByEmailIgnoreCase(request.email().trim())
                .orElseThrow(() -> new AuthException("No account found for this email."));

        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new AuthException("Incorrect password.");
        }
        applyReservedAdminRole(user);

        return new AuthResponse(
                user.getId(),
                user.getName(),
                user.getEmail(),
                user.getRole(),
                jwtService.createToken(user),
                "Login successful."
        );
    }

    private void applyReservedAdminRole(ParentUser user) {
        if (ADMIN_EMAIL.equalsIgnoreCase(user.getEmail()) && user.getRole() != UserRole.ADMIN) {
            user.setRole(UserRole.ADMIN);
            parentUserRepository.save(user);
        }
    }

    public void forgotPassword(ForgotPasswordRequest request) {
        String email = request.email().trim().toLowerCase();
        ParentUser user = parentUserRepository.findByEmailIgnoreCase(email)
                .orElseThrow(() -> new AuthException("No account found for this email."));

        String otp = String.format("%06d", new Random().nextInt(999999));
        user.setResetToken(otp);
        user.setResetTokenExpiry(LocalDateTime.now().plusHours(1));
        parentUserRepository.save(user);

        emailService.sendPasswordResetEmail(email, otp);
    }

    public void resetPassword(ResetPasswordRequest request) {
        ParentUser user = parentUserRepository.findByResetToken(request.token())
                .orElseThrow(() -> new AuthException("Invalid or expired reset token."));

        if (user.getResetTokenExpiry() == null || user.getResetTokenExpiry().isBefore(LocalDateTime.now())) {
            throw new AuthException("Invalid or expired reset token.");
        }

        user.setPasswordHash(passwordEncoder.encode(request.password()));
        user.setResetToken(null);
        user.setResetTokenExpiry(null);
        parentUserRepository.save(user);
    }
}
