package com.braingymacademy.app.practice;

import java.util.List;

public record PracticeSetResponse(
        String title,
        String description,
        List<PracticeQuestionResponse> questions
) {
}
