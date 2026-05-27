package com.braingymacademy.app.worksheet.dto;

import java.util.List;

public class WorksheetResponse {
    private String type;
    private int rows;
    private int columns;
    private List<List<Integer>> questions;
    private List<WorksheetPromptQuestion> promptQuestions;

    public WorksheetResponse() {
    }

    public WorksheetResponse(String type, int rows, int columns, List<List<Integer>> questions,
            List<WorksheetPromptQuestion> promptQuestions) {
        this.type = type;
        this.rows = rows;
        this.columns = columns;
        this.questions = questions;
        this.promptQuestions = promptQuestions;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getRows() {
        return rows;
    }

    public void setRows(int rows) {
        this.rows = rows;
    }

    public int getColumns() {
        return columns;
    }

    public void setColumns(int columns) {
        this.columns = columns;
    }

    public List<List<Integer>> getQuestions() {
        return questions;
    }

    public void setQuestions(List<List<Integer>> questions) {
        this.questions = questions;
    }

    public List<WorksheetPromptQuestion> getPromptQuestions() {
        return promptQuestions;
    }

    public void setPromptQuestions(List<WorksheetPromptQuestion> promptQuestions) {
        this.promptQuestions = promptQuestions;
    }
}
