package com.braingymacademy.app.practice;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class PracticeGenerationService {

    public List<PracticeSetResponse> formulaSets() {
        return List.of(
                new PracticeSetResponse(
                        "Big Friend",
                        "Worksheet-style practice using the 10-complement idea.",
                        bigFriendQuestions()
                ),
                new PracticeSetResponse(
                        "Small Friend",
                        "Worksheet-style practice using the 5-complement idea.",
                        smallFriendQuestions()
                ),
                new PracticeSetResponse(
                        "Combo Practice",
                        "Combo sums like 5 + 9: add 10, then remove the big friend complement.",
                        comboQuestions()
                )
        );
    }

    public DirectPracticeResponse directPractice() {
        List<WorksheetQuestionResponse> warmups = directWarmupWorksheet();
        List<WorksheetQuestionResponse> additions = directAdditionWorksheet();
        List<WorksheetQuestionResponse> subtractions = directSubtractionWorksheet();

        List<WorksheetQuestionResponse> worksheet = new ArrayList<>();
        worksheet.addAll(warmups);
        worksheet.addAll(additions);
        worksheet.addAll(subtractions);

        List<PracticeQuestionResponse> practiceBank = new ArrayList<>();
        for (int index = 0; index < 500; index++) {
            WorksheetQuestionResponse question = worksheet.get(index % worksheet.size());
            practiceBank.add(new PracticeQuestionResponse(
                    "%d %s %d".formatted(question.top(), question.operator(), question.bottom())
            ));
        }

        return new DirectPracticeResponse(
                List.of(
                        new WorksheetSectionResponse("Single Rod Warmup", warmups),
                        new WorksheetSectionResponse("Two Rod Direct Addition", additions),
                        new WorksheetSectionResponse("Two Rod Direct Subtraction", subtractions)
                ),
                practiceBank
        );
    }

    private List<PracticeQuestionResponse> smallFriendQuestions() {
        String[] templates = {
                "4 + 1", "3 + 2", "2 + 3", "1 + 4", "6 - 1",
                "7 - 2", "8 - 3", "9 - 4", "5 - 1", "5 - 2"
        };
        List<PracticeQuestionResponse> questions = new ArrayList<>();
        for (int index = 0; index < 50; index++) {
            questions.add(new PracticeQuestionResponse(templates[index % templates.length]));
        }
        return questions;
    }

    private List<PracticeQuestionResponse> bigFriendQuestions() {
        List<PracticeQuestionResponse> questions = new ArrayList<>();

        for (int start = 1; start <= 89 && questions.size() < 25; start++) {
            for (int add = 6; add <= 9 && questions.size() < 25; add++) {
                int ones = start % 10;
                int answer = start + add;
                if (answer <= 99 && ones > 0 && ones + add >= 10) {
                    questions.add(new PracticeQuestionResponse("%d + %d".formatted(start, add)));
                }
            }
        }

        for (int start = 10; start <= 99 && questions.size() < 50; start++) {
            for (int subtract = 6; subtract <= 9 && questions.size() < 50; subtract++) {
                int ones = start % 10;
                int answer = start - subtract;
                if (answer >= 0 && ones < subtract) {
                    questions.add(new PracticeQuestionResponse("%d - %d".formatted(start, subtract)));
                }
            }
        }

        return questions;
    }

    private List<PracticeQuestionResponse> comboQuestions() {
        int[][] additionSeeds = {
                {5, 6}, {5, 7}, {5, 8}, {5, 9},
                {6, 6}, {6, 7}, {6, 8}, {6, 9},
                {7, 6}, {7, 7}, {7, 8}, {7, 9},
                {8, 6}, {8, 7}, {8, 8}, {8, 9},
                {9, 6}, {9, 7}, {9, 8}, {9, 9}
        };
        int[][] subtractionSeeds = {
                {11, 6}, {12, 6}, {12, 7},
                {13, 6}, {13, 7}, {13, 8},
                {14, 6}, {14, 7}, {14, 8}, {14, 9},
                {15, 6}, {15, 7}, {15, 8}, {15, 9},
                {16, 7}, {16, 8}, {16, 9},
                {17, 8}, {17, 9},
                {18, 9}
        };

        List<PracticeQuestionResponse> seeds = new ArrayList<>();
        for (int[] seed : additionSeeds) {
            seeds.add(new PracticeQuestionResponse("%d + %d".formatted(seed[0], seed[1])));
        }
        for (int[] seed : subtractionSeeds) {
            seeds.add(new PracticeQuestionResponse("%d - %d".formatted(seed[0], seed[1])));
        }

        List<PracticeQuestionResponse> questions = new ArrayList<>();
        for (int index = 0; index < 50; index++) {
            questions.add(seeds.get(index % seeds.size()));
        }
        return questions;
    }

    private List<WorksheetQuestionResponse> directWarmupWorksheet() {
        Object[][] seeds = {
                {0, "+", 1}, {1, "+", 2}, {2, "+", 2},
                {5, "+", 1}, {6, "+", 2},
                {9, "-", 1}, {8, "-", 2}, {7, "-", 2}, {4, "-", 1}, {3, "-", 2},
                {0, "+", 5}, {1, "+", 5}, {2, "+", 5},
                {5, "-", 5}, {6, "-", 5}, {9, "-", 5},
                {10, "+", 10}, {20, "+", 20}, {80, "-", 10}, {70, "-", 20}
        };

        List<WorksheetQuestionResponse> questions = new ArrayList<>();
        for (Object[] seed : seeds) {
            int top = (int) seed[0];
            String operator = (String) seed[1];
            int bottom = (int) seed[2];
            questions.add(new WorksheetQuestionResponse(
                    top,
                    operator,
                    bottom,
                    "+".equals(operator) ? top + bottom : top - bottom
            ));
        }
        return questions;
    }

    private List<WorksheetQuestionResponse> directAdditionWorksheet() {
        List<WorksheetQuestionResponse> questions = new ArrayList<>();
        int[][] seeds = {
                {11, 11}, {11, 12}, {12, 11}, {12, 12}, {13, 11},
                {20, 12}, {20, 22}, {21, 12}, {21, 13}, {22, 12},
                {22, 22}, {23, 11}, {23, 21}, {30, 11}, {30, 14},
                {31, 12}, {31, 13}, {32, 11}, {32, 12}, {33, 11},
                {50, 21}, {50, 23}, {51, 12}, {51, 22}, {52, 11},
                {52, 21}, {53, 11}, {60, 12}, {61, 11}, {62, 12}
        };

        for (int[] seed : seeds) {
            int top = seed[0];
            int bottom = seed[1];
            if (isDirectTwoDigitMove(top, bottom)) {
                questions.add(new WorksheetQuestionResponse(top, "+", bottom, top + bottom));
            }
        }

        return questions;
    }

    private List<WorksheetQuestionResponse> directSubtractionWorksheet() {
        List<WorksheetQuestionResponse> questions = new ArrayList<>();

        for (int top = 99; top >= 0 && questions.size() < 30; top--) {
            for (int bottom = 1; bottom <= 55 && questions.size() < 30; bottom++) {
                if (isDirectTwoDigitMove(top, -bottom)) {
                    questions.add(new WorksheetQuestionResponse(top, "-", bottom, top - bottom));
                }
            }
        }

        return questions;
    }

    private boolean isDirectTwoDigitMove(int start, int delta) {
        int end = start + delta;
        if (end < 0 || end > 99) {
            return false;
        }

        int startTens = start / 10;
        int startOnes = start % 10;
        int deltaMagnitude = Math.abs(delta);
        int deltaTens = deltaMagnitude / 10;
        int deltaOnes = deltaMagnitude % 10;
        int sign = delta >= 0 ? 1 : -1;

        return isDirectDigitMove(startTens, sign * deltaTens)
                && isDirectDigitMove(startOnes, sign * deltaOnes);
    }

    private boolean isDirectDigitMove(int startDigit, int delta) {
        if (delta == 0) {
            return true;
        }

        int lowerBeads = startDigit % 5;
        boolean topBeadActive = startDigit >= 5;

        if (delta > 0) {
            if (delta == 5) {
                return !topBeadActive;
            }
            if (delta > 5) {
                return false;
            }
            return lowerBeads + delta <= 4;
        }

        int remove = -delta;
        if (remove == 5) {
            return topBeadActive;
        }
        if (remove > 5) {
            return false;
        }
        return lowerBeads >= remove;
    }
}
