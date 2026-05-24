package com.braingymacademy.app.auth;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ParentUserRepository extends JpaRepository<ParentUser, Long> {

    boolean existsByEmailIgnoreCase(String email);

    Optional<ParentUser> findByEmailIgnoreCase(String email);

    Optional<ParentUser> findByResetToken(String resetToken);
}
