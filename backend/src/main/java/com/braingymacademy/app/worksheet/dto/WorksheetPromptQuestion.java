package com.braingymacademy.app.worksheet.dto;

public class WorksheetPromptQuestion {
    private int top;
    private String operator;
    private int bottom;
    private int answer;

    public WorksheetPromptQuestion() {
    }

    public WorksheetPromptQuestion(int top, String operator, int bottom, int answer) {
        this.top = top;
        this.operator = operator;
        this.bottom = bottom;
        this.answer = answer;
    }

    public int getTop() {
        return top;
    }

    public void setTop(int top) {
        this.top = top;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public int getBottom() {
        return bottom;
    }

    public void setBottom(int bottom) {
        this.bottom = bottom;
    }

    public int getAnswer() {
        return answer;
    }

    public void setAnswer(int answer) {
        this.answer = answer;
    }
}
