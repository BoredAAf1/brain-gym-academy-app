package com.braingymacademy.app.progress;

import com.braingymacademy.app.auth.ParentUser;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class ProgressService {

    private final UserProgressRepository userProgressRepository;

    public ProgressService(UserProgressRepository userProgressRepository) {
        this.userProgressRepository = userProgressRepository;
    }

    @Transactional
    public List<ProgressResponse> summary(ParentUser parentUser) {
        Map<ProgressArea, UserProgress> savedProgress = userProgressRepository.findByParentUserId(parentUser.getId())
                .stream()
                .collect(Collectors.toMap(UserProgress::getArea, Function.identity()));

        return Arrays.stream(ProgressArea.values())
                .map(area -> {
                    UserProgress progress = savedProgress.computeIfAbsent(
                            area,
                            missingArea -> userProgressRepository.save(new UserProgress(parentUser, missingArea))
                    );
                    return toResponse(progress);
                })
                .toList();
    }

    @Transactional
    public ProgressResponse markComplete(ParentUser parentUser, String rawArea) {
        ProgressArea area = parseArea(rawArea);
        UserProgress progress = userProgressRepository
                .findByParentUserIdAndArea(parentUser.getId(), area)
                .orElseGet(() -> userProgressRepository.save(new UserProgress(parentUser, area)));

        progress.markComplete();
        return toResponse(progress);
    }

    private ProgressArea parseArea(String rawArea) {
        try {
            return ProgressArea.valueOf(rawArea);
        } catch (IllegalArgumentException exception) {
            throw new ProgressException("Progress area was not recognized.");
        }
    }

    private ProgressResponse toResponse(UserProgress progress) {
        ProgressArea area = progress.getArea();
        return new ProgressResponse(area.name(), area.getTitle(), progress.getCompleted(), area.getTotal());
    }
}
