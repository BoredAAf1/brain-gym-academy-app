package com.braingymacademy.app.students;

import com.braingymacademy.app.auth.JwtService;
import com.braingymacademy.app.auth.ParentUser;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/students")
public class StudentProfileController {

    private final StudentProfileService studentProfileService;
    private final JwtService jwtService;

    public StudentProfileController(StudentProfileService studentProfileService, JwtService jwtService) {
        this.studentProfileService = studentProfileService;
        this.jwtService = jwtService;
    }

    @GetMapping
    public List<StudentResponse> getStudents(@RequestHeader("Authorization") String authorizationHeader) {
        ParentUser parentUser = jwtService.requireUser(authorizationHeader);
        return studentProfileService.getStudents(parentUser.getId());
    }

    @PostMapping
    public StudentResponse createStudent(
            @RequestHeader("Authorization") String authorizationHeader,
            @Valid @RequestBody StudentRequest request
    ) {
        ParentUser parentUser = jwtService.requireUser(authorizationHeader);
        return studentProfileService.createStudent(parentUser.getId(), request);
    }

    @PutMapping("/{studentId}")
    public StudentResponse updateStudent(
            @RequestHeader("Authorization") String authorizationHeader,
            @PathVariable Long studentId,
            @Valid @RequestBody StudentRequest request
    ) {
        ParentUser parentUser = jwtService.requireUser(authorizationHeader);
        return studentProfileService.updateStudent(parentUser.getId(), studentId, request);
    }

    @DeleteMapping("/{studentId}")
    public void deleteStudent(
            @RequestHeader("Authorization") String authorizationHeader,
            @PathVariable Long studentId
    ) {
        ParentUser parentUser = jwtService.requireUser(authorizationHeader);
        studentProfileService.deleteStudent(studentId, parentUser.getId());
    }
}
