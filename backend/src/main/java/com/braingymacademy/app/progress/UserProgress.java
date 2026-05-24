package com.braingymacademy.app.progress;

import com.braingymacademy.app.auth.ParentUser;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(
        name = "user_progress",
        uniqueConstraints = @UniqueConstraint(columnNames = {"parent_user_id", "area"})
)
public class UserProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "parent_user_id", nullable = false)
    private ParentUser parentUser;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ProgressArea area;

    @Column(nullable = false)
    private Integer completed;

    protected UserProgress() {
    }

    public UserProgress(ParentUser parentUser, ProgressArea area) {
        this.parentUser = parentUser;
        this.area = area;
        this.completed = 0;
    }

    public ProgressArea getArea() {
        return area;
    }

    public Integer getCompleted() {
        return completed;
    }

    public void markComplete() {
        completed = Math.min(completed + 1, area.getTotal());
    }
}
