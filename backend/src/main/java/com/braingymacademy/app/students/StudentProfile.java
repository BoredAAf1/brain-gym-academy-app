package com.braingymacademy.app.students;

import com.braingymacademy.app.auth.ParentUser;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "student_profiles")
public class StudentProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "parent_user_id", nullable = false)
    private ParentUser parentUser;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private Integer age;

    @Column(nullable = false)
    private String level;

    protected StudentProfile() {
    }

    public StudentProfile(ParentUser parentUser, String name, Integer age, String level) {
        this.parentUser = parentUser;
        this.name = name;
        this.age = age;
        this.level = level;
    }

    public Long getId() {
        return id;
    }

    public ParentUser getParentUser() {
        return parentUser;
    }

    public String getName() {
        return name;
    }

    public Integer getAge() {
        return age;
    }

    public String getLevel() {
        return level;
    }

    public void update(String name, Integer age, String level) {
        this.name = name;
        this.age = age;
        this.level = level;
    }
}
