package com.braingymacademy.app.students;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface StudentProfileRepository extends JpaRepository<StudentProfile, Long> {

    List<StudentProfile> findAllByParentUserIdOrderByNameAsc(Long parentUserId);

    Optional<StudentProfile> findByIdAndParentUserId(Long id, Long parentUserId);
}
