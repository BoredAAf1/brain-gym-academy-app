package com.braingymacademy.app.progress;

public record ProgressResponse(
        String area,
        String title,
        int completed,
        int total
) {
}
