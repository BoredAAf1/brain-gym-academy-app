package com.braingymacademy.app.students;

import com.braingymacademy.app.progress.ProgressArea;
import com.braingymacademy.app.progress.UserProgress;
import com.braingymacademy.app.progress.UserProgressRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class StudentRecommendationService {

    private final UserProgressRepository userProgressRepository;

    public StudentRecommendationService(UserProgressRepository userProgressRepository) {
        this.userProgressRepository = userProgressRepository;
    }

    public List<String> recommendationsFor(StudentProfile studentProfile) {
        List<UserProgress> progressList = userProgressRepository
                .findByParentUserId(studentProfile.getParentUser().getId());
        Map<ProgressArea, Integer> completedByArea = progressList.stream()
                .collect(Collectors.toMap(UserProgress::getArea, UserProgress::getCompleted));

        int totalCompleted = completedByArea.values().stream().mapToInt(Integer::intValue).sum();
        List<String> recommendations = new ArrayList<>();
        String level = studentProfile.getLevel().toLowerCase();

        if (level.contains("beginner")) {
            recommendations.add("Build confidence with short Direct Soroban sessions for one-digit problems.");
            recommendations.add("Use 0–99 representation drills to deepen bead-to-number recall.");
            recommendations.add("Repeat small formula sets until the learner feels fast and accurate.");
        } else if (level.contains("intermediate")) {
            recommendations.add("Practice Formula worksheets to improve big-friend and small-friend speed.");
            recommendations.add("Add more two-digit sums and subtraction practice for stronger mental math.");
            recommendations.add("Review Direct Sum routines before increasing problem size.");
        } else if (level.contains("advanced")) {
            recommendations.add("Challenge with two-digit × two-digit questions and long division worksheets.");
            recommendations.add("Alternate Soroban sessions with phonics drills to keep practice balanced.");
            recommendations.add("Set a weekly goal to keep the learner building consistency.");
        } else {
            recommendations
                    .add("Rotate between Direct, Formula, and Worksheet sessions for balanced Soroban practice.");
            recommendations.add("Check progress each week and tune the next session to the learner’s strongest area.");
        }

        if (totalCompleted == 0) {
            recommendations.add("Start a short practice session now to build a consistent routine.");
        } else if (totalCompleted < 4) {
            recommendations.add("Aim for at least 4 sessions this week for steady growth.");
        } else {
            recommendations.add("Keep the momentum going with frequent, focused practice.");
        }

        int formulaCompleted = completedByArea.getOrDefault(ProgressArea.FORMULA_PRACTICE, 0);
        if (formulaCompleted < 2) {
            recommendations.add("Spend a little extra time on Formula Practice to strengthen pattern recall.");
        }

        int directCompleted = completedByArea.getOrDefault(ProgressArea.DIRECT_SUMS, 0);
        if (directCompleted < 2) {
            recommendations.add("Add a few Direct Sum drills to reinforce rapid addition and subtraction.");
        }

        return recommendations;
    }
}
