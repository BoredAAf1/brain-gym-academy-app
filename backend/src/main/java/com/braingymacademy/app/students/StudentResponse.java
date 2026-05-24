package com.braingymacademy.app.students;

public record StudentResponse(
        Long id,
        Long parentUserId,
        String name,
        Integer age,
        String level
) {
    public static StudentResponse from(StudentProfile studentProfile) {
        return new StudentResponse(
                studentProfile.getId(),
                studentProfile.getParentUser().getId(),
                studentProfile.getName(),
                studentProfile.getAge(),
                studentProfile.getLevel()
        );
    }
}
