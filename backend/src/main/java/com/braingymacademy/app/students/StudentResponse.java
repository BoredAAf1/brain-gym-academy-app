package com.braingymacademy.app.students;

import java.util.List;

public record StudentResponse(
        Long id,
        Long parentUserId,
        String name,
        Integer age,
        String level,
        List<String> recommendations) {
    public static StudentResponse from(StudentProfile studentProfile, List<String> recommendations) {
        return new StudentResponse(
                studentProfile.getId(),
                studentProfile.getParentUser().getId(),
                studentProfile.getName(),
                studentProfile.getAge(),
                studentProfile.getLevel(),
                recommendations);
    }
}
