package com.braingymacademy.app.worksheet;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;

import com.braingymacademy.app.worksheet.dto.WorksheetResponse;

@RestController
@RequestMapping("/api/worksheets")
public class WorksheetController {

    private final WorksheetService service;

    @Autowired
    public WorksheetController(WorksheetService service) {
        this.service = service;
    }

    @GetMapping("/abacus/{type}")
    public WorksheetResponse getAbacusWorksheet(@PathVariable String type) {
        return service.generateAbacusWorksheet(type);
    }

    @GetMapping("/arithmetic/{type}")
    public WorksheetResponse getArithmeticWorksheet(@PathVariable String type) {
        return service.generateArithmeticWorksheet(type);
    }
}
