package com.braingymacademy.app.worksheet;

import org.springframework.stereotype.Service;
import com.braingymacademy.app.worksheet.dto.WorksheetResponse;
import com.braingymacademy.app.worksheet.dto.WorksheetPromptQuestion;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.List;

@Service
public class WorksheetService {
    private final SecureRandom random = new SecureRandom();

    public WorksheetResponse generateAbacusWorksheet(String type) {
        return switch (type) {
            case "1digit-5rows-100" -> createAbacusWorksheet(type, 5, 1, 100);
            case "1digit-10rows-100" -> createAbacusWorksheet(type, 10, 1, 100);
            case "2digit-5values-100" -> createAbacusWorksheet(type, 5, 2, 100);
            case "3digit-3values-100" -> createAbacusWorksheet(type, 3, 3, 100);
            default -> throw new IllegalArgumentException("Unknown abacus worksheet type: " + type);
        };
    }

    public WorksheetResponse generateArithmeticWorksheet(String type) {
        return switch (type) {
            case "multiply-2digit-1digit-100" ->
                createArithmeticWorksheet(type, generateMultiplicationQuestions(2, 1, 100));
            case "multiply-2digit-2digit-100" ->
                createArithmeticWorksheet(type, generateMultiplicationQuestions(2, 2, 100));
            case "divide-3digit-1digit-100" -> createArithmeticWorksheet(type, generateDivisionQuestions(3, 1, 100));
            case "divide-4digit-2digit-100" -> createArithmeticWorksheet(type, generateDivisionQuestions(4, 2, 100));
            default -> throw new IllegalArgumentException("Unknown arithmetic worksheet type: " + type);
        };
    }

    private WorksheetResponse createAbacusWorksheet(String type, int columns, int digitLength, int questionCount) {
        List<List<Integer>> questions = new ArrayList<>();
        for (int q = 0; q < questionCount; q++) {
            List<Integer> questionRow = new ArrayList<>();
            int runningTotal = randomValue(digitLength, false);
            questionRow.add(runningTotal);
            for (int c = 1; c < columns; c++) {
                int value;
                do {
                    value = randomValue(digitLength, true);
                } while (runningTotal + value < 0);
                questionRow.add(value);
                runningTotal += value;
            }
            questions.add(questionRow);
        }
        return new WorksheetResponse(type, questionCount, columns, questions, null);
    }

    private WorksheetResponse createArithmeticWorksheet(String type, List<WorksheetPromptQuestion> questions) {
        return new WorksheetResponse(type, questions.size(), 1, null, questions);
    }

    private int randomValue(int digitLength, boolean allowNegative) {
        int min = (int) Math.pow(10, digitLength - 1);
        int max = (int) Math.pow(10, digitLength) - 1;
        if (digitLength == 1) {
            min = 1;
            max = 9;
        }

        int value = random.nextInt(max - min + 1) + min;
        if (allowNegative && random.nextBoolean()) {
            value = -value;
        }
        return value;

        // Previous implementation always returned a positive value even when negatives
        // were allowed:
        // int min = (int) Math.pow(10, digitLength - 1);
        // int max = (int) Math.pow(10, digitLength) - 1;
        // if (digitLength == 1) {
        // min = 1;
        // max = 9;
        // }
        // return random.nextInt(max - min + 1) + min;
    }

    private List<WorksheetPromptQuestion> generateMultiplicationQuestions(int topDigits, int bottomDigits, int count) {
        List<WorksheetPromptQuestion> questions = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            int top = randomPositiveDigitValue(topDigits);
            int bottom = randomPositiveDigitValue(bottomDigits);
            questions.add(new WorksheetPromptQuestion(top, "×", bottom, top * bottom));
        }
        return questions;
    }

    private List<WorksheetPromptQuestion> generateDivisionQuestions(int topDigits, int bottomDigits, int count) {
        List<WorksheetPromptQuestion> questions = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            int top;
            int bottom;
            int quotient;
            do {
                bottom = randomPositiveDigitValue(bottomDigits);
                quotient = randomPositiveDigitValue(Math.max(1, topDigits - bottomDigits));
                top = bottom * quotient;
            } while (String.valueOf(top).length() != topDigits);
            questions.add(new WorksheetPromptQuestion(top, "÷", bottom, quotient));
        }
        return questions;
    }

    private int randomPositiveDigitValue(int digits) {
        int min = (int) Math.pow(10, digits - 1);
        int max = (int) Math.pow(10, digits) - 1;
        if (digits == 1) {
            min = 1;
            max = 9;
        }
        return random.nextInt(max - min + 1) + min;
    }
}
