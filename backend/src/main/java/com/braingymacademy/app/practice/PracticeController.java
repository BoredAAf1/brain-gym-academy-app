package com.braingymacademy.app.practice;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/practice")
public class PracticeController {

    private final PracticeGenerationService practiceGenerationService;

    public PracticeController(PracticeGenerationService practiceGenerationService) {
        this.practiceGenerationService = practiceGenerationService;
    }

    @GetMapping("/formula")
    public List<PracticeSetResponse> formulaSets() {
        return practiceGenerationService.formulaSets();
    }

    @GetMapping("/direct")
    public DirectPracticeResponse directPractice() {
        return practiceGenerationService.directPractice();
    }
}
