package com.braingymacademy.app.practice;

import java.util.List;

public record DirectPracticeResponse(
        List<WorksheetSectionResponse> sections,
        List<PracticeQuestionResponse> practiceBank
) {
}
