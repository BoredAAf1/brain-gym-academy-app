package com.braingymacademy.app.worksheet;

import com.braingymacademy.app.worksheet.dto.WorksheetResponse;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class WorksheetServiceTests {

    private final WorksheetService worksheetService = new WorksheetService();

    @Test
    void generateAbacusWorksheetShouldNeverProduceNegativeIntermediateSums() {
        WorksheetResponse response = worksheetService.generateAbacusWorksheet("1digit-5rows-100");

        assertNotNull(response.getQuestions());
        assertEquals(100, response.getQuestions().size());

        response.getQuestions().forEach(row -> {
            assertEquals(5, row.size());
            int runningTotal = 0;
            for (int value : row) {
                runningTotal += value;
                assertTrue(runningTotal >= 0,
                        "Expected non-negative running total but got " + runningTotal + " for value " + value);
            }
        });
    }

    @Test
    void generateTwoDigitAbacusWorksheetShouldNeverProduceNegativeIntermediateSums() {
        WorksheetResponse response = worksheetService.generateAbacusWorksheet("2digit-5values-100");

        assertNotNull(response.getQuestions());
        assertEquals(100, response.getQuestions().size());

        response.getQuestions().forEach(row -> {
            assertEquals(5, row.size());
            int runningTotal = 0;
            for (int value : row) {
                runningTotal += value;
                assertTrue(runningTotal >= 0,
                        "Expected non-negative running total but got " + runningTotal + " for value " + value);
            }
        });
    }
}
