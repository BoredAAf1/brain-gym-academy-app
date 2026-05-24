package com.braingymacademy.app.students;

import com.braingymacademy.app.auth.ParentUser;
import com.braingymacademy.app.auth.ParentUserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudentProfileService {

    private final StudentProfileRepository studentProfileRepository;
    private final ParentUserRepository parentUserRepository;

    public StudentProfileService(StudentProfileRepository studentProfileRepository,
                                 ParentUserRepository parentUserRepository) {
        this.studentProfileRepository = studentProfileRepository;
        this.parentUserRepository = parentUserRepository;
    }

    public List<StudentResponse> getStudents(Long parentUserId) {
        return studentProfileRepository.findAllByParentUserIdOrderByNameAsc(parentUserId)
                .stream()
                .map(StudentResponse::from)
                .toList();
    }

    public StudentResponse createStudent(Long parentUserId, StudentRequest request) {
        ParentUser parentUser = parentUserRepository.findById(parentUserId)
                .orElseThrow(() -> new StudentException("Parent user not found."));

        StudentProfile saved = studentProfileRepository.save(
                new StudentProfile(
                        parentUser,
                        request.name().trim(),
                        request.age(),
                        request.level().trim()
                )
        );

        return StudentResponse.from(saved);
    }

    public StudentResponse updateStudent(Long parentUserId, Long studentId, StudentRequest request) {
        StudentProfile student = studentProfileRepository.findByIdAndParentUserId(studentId, parentUserId)
                .orElseThrow(() -> new StudentException("Student profile not found."));

        student.update(request.name().trim(), request.age(), request.level().trim());
        return StudentResponse.from(studentProfileRepository.save(student));
    }

    public void deleteStudent(Long studentId, Long parentUserId) {
        StudentProfile student = studentProfileRepository.findByIdAndParentUserId(studentId, parentUserId)
                .orElseThrow(() -> new StudentException("Student profile not found."));

        studentProfileRepository.delete(student);
    }
}
