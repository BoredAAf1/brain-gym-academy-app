package com.braingymacademy.app.progress;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserProgressRepository extends JpaRepository<UserProgress, Long> {
    List<UserProgress> findByParentUserId(Long parentUserId);

    Optional<UserProgress> findByParentUserIdAndArea(Long parentUserId, ProgressArea area);
}
