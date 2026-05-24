package com.braingymacademy.app.practice;

public record WorksheetQuestionResponse(
        int top,
        String operator,
        int bottom,
        int answer
) {
}
