package com.braingymacademy.app.progress;

import com.braingymacademy.app.auth.JwtService;
import com.braingymacademy.app.auth.ParentUser;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/progress")
public class ProgressController {

    private final JwtService jwtService;
    private final ProgressService progressService;

    public ProgressController(JwtService jwtService, ProgressService progressService) {
        this.jwtService = jwtService;
        this.progressService = progressService;
    }

    @GetMapping
    public List<ProgressResponse> summary(@RequestHeader("Authorization") String authorizationHeader) {
        ParentUser parentUser = jwtService.requireUser(authorizationHeader);
        return progressService.summary(parentUser);
    }

    @PostMapping("/complete")
    public ProgressResponse markComplete(
            @RequestHeader("Authorization") String authorizationHeader,
            @Valid @RequestBody ProgressCompleteRequest request
    ) {
        ParentUser parentUser = jwtService.requireUser(authorizationHeader);
        return progressService.markComplete(parentUser, request.area());
    }
}
