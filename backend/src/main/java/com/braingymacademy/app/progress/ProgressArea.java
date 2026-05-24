package com.braingymacademy.app.progress;

public enum ProgressArea {
    SOROBAN_REPRESENTATION("Soroban Representation", 100),
    FORMULA_PRACTICE("Formula Practice", 150),
    DIRECT_SUMS("Direct Sums", 500),
    PHONICS("Phonics", 110);

    private final String title;
    private final int total;

    ProgressArea(String title, int total) {
        this.title = title;
        this.total = total;
    }

    public String getTitle() {
        return title;
    }

    public int getTotal() {
        return total;
    }
}
