package com.braingymacademy.app.practice;

import java.util.List;

public record WorksheetSectionResponse(
        String title,
        List<WorksheetQuestionResponse> questions
) {
}
