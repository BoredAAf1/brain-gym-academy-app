package com.braingymacademy.app.students;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record StudentRequest(
        @NotBlank(message = "Student name is required")
        String name,
        @NotNull(message = "Age is required")
        @Min(value = 3, message = "Age must be at least 3")
        @Max(value = 18, message = "Age must be at most 18")
        Integer age,
        @NotBlank(message = "Level is required")
        String level
) {
}
