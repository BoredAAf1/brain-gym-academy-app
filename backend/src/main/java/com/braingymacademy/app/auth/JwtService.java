package com.braingymacademy.app.auth;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;

@Service
public class JwtService {

    private static final String HMAC_ALGORITHM = "HmacSHA256";
    private static final long TOKEN_TTL_SECONDS = 60L * 60L * 24L * 7L;

    private final String secret;
    private final ParentUserRepository parentUserRepository;

    public JwtService(
            @Value("${app.jwt.secret:brain-gym-academy-local-dev-secret-key-change-before-deployment}") String secret,
            ParentUserRepository parentUserRepository
    ) {
        this.secret = secret;
        this.parentUserRepository = parentUserRepository;
    }

    public String createToken(ParentUser parentUser) {
        long now = Instant.now().getEpochSecond();
        long expiresAt = now + TOKEN_TTL_SECONDS;
        String header = encodeJson("""
                {"alg":"HS256","typ":"JWT"}
                """);
        String payload = encodeJson("""
                {"sub":%d,"email":"%s","name":"%s","role":"%s","iat":%d,"exp":%d}
                """.formatted(
                parentUser.getId(),
                escapeJson(parentUser.getEmail()),
                escapeJson(parentUser.getName()),
                parentUser.getRole().name(),
                now,
                expiresAt
        ));
        String signature = sign(header + "." + payload);
        return header + "." + payload + "." + signature;
    }

    public ParentUser requireUser(String authorizationHeader) {
        String token = extractBearerToken(authorizationHeader);
        String[] parts = token.split("\\.");
        if (parts.length != 3) {
            throw new AuthException("Session expired. Please sign in again.");
        }

        String expectedSignature = sign(parts[0] + "." + parts[1]);
        if (!constantTimeEquals(expectedSignature, parts[2])) {
            throw new AuthException("Session expired. Please sign in again.");
        }

        String payload = decodePayload(parts[1]);
        requireNotExpired(payload);
        Long parentUserId = extractNumericClaim(payload, "sub");
        return parentUserRepository.findById(parentUserId)
                .orElseThrow(() -> new AuthException("Authenticated parent account was not found."));
    }

    private String extractBearerToken(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            throw new AuthException("Login is required.");
        }

        return authorizationHeader.substring("Bearer ".length()).trim();
    }

    private String encodeJson(String json) {
        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(json.trim().getBytes(StandardCharsets.UTF_8));
    }

    private String sign(String value) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM));
            return Base64.getUrlEncoder()
                    .withoutPadding()
                    .encodeToString(mac.doFinal(value.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception exception) {
            throw new AuthException("Could not create login session.");
        }
    }

    private String decodePayload(String encodedPayload) {
        try {
            return new String(Base64.getUrlDecoder().decode(encodedPayload), StandardCharsets.UTF_8);
        } catch (IllegalArgumentException exception) {
            throw new AuthException("Session expired. Please sign in again.");
        }
    }

    private void requireNotExpired(String payload) {
        long expiresAt = extractNumericClaim(payload, "exp");
        if (expiresAt < Instant.now().getEpochSecond()) {
            throw new AuthException("Session expired. Please sign in again.");
        }
    }

    private Long extractNumericClaim(String payload, String claimName) {
        String marker = "\"%s\":".formatted(claimName);
        int start = payload.indexOf(marker);
        if (start < 0) {
            throw new AuthException("Session expired. Please sign in again.");
        }

        int valueStart = start + marker.length();
        int valueEnd = valueStart;
        while (valueEnd < payload.length() && Character.isDigit(payload.charAt(valueEnd))) {
            valueEnd++;
        }

        if (valueEnd == valueStart) {
            throw new AuthException("Session expired. Please sign in again.");
        }

        return Long.parseLong(payload.substring(valueStart, valueEnd));
    }

    private boolean constantTimeEquals(String left, String right) {
        return MessageDigest.isEqual(
                left.getBytes(StandardCharsets.UTF_8),
                right.getBytes(StandardCharsets.UTF_8)
        );
    }

    private String escapeJson(String value) {
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }
}
