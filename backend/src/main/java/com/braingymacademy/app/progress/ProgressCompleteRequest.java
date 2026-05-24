package com.braingymacademy.app.progress;

import jakarta.validation.constraints.NotBlank;

public record ProgressCompleteRequest(
        @NotBlank(message = "Progress area is required.")
        String area
) {
}
