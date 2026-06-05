package com.braingymacademy.app.students;

import com.braingymacademy.app.auth.ParentUser;
import com.braingymacademy.app.auth.ParentUserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class StudentProfileService {

        private final StudentProfileRepository studentProfileRepository;
        private final ParentUserRepository parentUserRepository;
        private final StudentRecommendationService recommendationService;

        public StudentProfileService(StudentProfileRepository studentProfileRepository,
                        ParentUserRepository parentUserRepository,
                        StudentRecommendationService recommendationService) {
                this.studentProfileRepository = studentProfileRepository;
                this.parentUserRepository = parentUserRepository;
                this.recommendationService = recommendationService;
        }

        public List<StudentResponse> getStudents(Long parentUserId) {
                return studentProfileRepository.findAllByParentUserIdOrderByNameAsc(parentUserId)
                                .stream()
                                .map(student -> StudentResponse.from(student,
                                                recommendationService.recommendationsFor(student)))
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
                                                request.level().trim()));

                return StudentResponse.from(saved, recommendationService.recommendationsFor(saved));
        }

        public StudentResponse updateStudent(Long parentUserId, Long studentId, StudentRequest request) {
                StudentProfile student = studentProfileRepository.findByIdAndParentUserId(studentId, parentUserId)
                                .orElseThrow(() -> new StudentException("Student profile not found."));

                student.update(request.name().trim(), request.age(), request.level().trim());
                StudentProfile updated = studentProfileRepository.save(student);
                return StudentResponse.from(updated, recommendationService.recommendationsFor(updated));
        }

        public void deleteStudent(Long studentId, Long parentUserId) {
                StudentProfile student = studentProfileRepository.findByIdAndParentUserId(studentId, parentUserId)
                                .orElseThrow(() -> new StudentException("Student profile not found."));

                studentProfileRepository.delete(student);
        }
}
