# System Design

## Goal

Build a web-first learning app for:

- Soroban practice
- Phonics practice
- Student progress tracking
- Parent login and student management

The app should launch on web first, then stay open to Android/iOS later.

## High-level architecture

### Frontend

- Flutter Web
- Responsive UI for desktop and tablet first
- Feature-based folder structure
- REST API calls to Spring Boot backend

### Backend

- Spring Boot REST API
- Authentication, student management, progress tracking, content delivery
- PostgreSQL persistence
- JWT-based auth in later auth phase

### Database

- PostgreSQL
- Normalized relational schema
- Clear ownership between parent accounts and student profiles

## Main modules

### 1. Authentication

- Parent signup/login
- Later Google login
- Password reset later

### 2. Student Profiles

- One parent can manage multiple students
- Student name
- Age
- Level
- Active modules

### 3. Soroban

- Virtual soroban free-play
- Number representation
- Guided practice
- Formula practice
- Direct sums
- Session results

### 4. Phonics

- Sounds
- Sound cards
- Word groups
- Tricky words
- Audio support later

### 5. Progress

- Topic progress
- Accuracy
- Completion history
- Weak-area identification

## Suggested backend domains

- `auth`
- `users`
- `students`
- `soroban`
- `phonics`
- `progress`
- `common`

## Suggested frontend features

- `auth`
- `dashboard`
- `students`
- `soroban`
- `phonics`
- `progress`
- `shared`

## Core entities

### ParentUser

- id
- name
- email
- password_hash
- auth_provider
- created_at

### StudentProfile

- id
- parent_user_id
- name
- age
- level
- created_at

### SorobanPracticeSet

- id
- title
- category
- difficulty

### SorobanQuestion

- id
- practice_set_id
- prompt
- answer
- display_type

### PhonicsSound

- id
- symbol
- sound_key
- description

### PhonicsWord

- id
- phonics_sound_id
- word

### TrickyWord

- id
- word
- level

### PracticeSession

- id
- student_profile_id
- module_type
- started_at
- completed_at
- score

### PracticeResponse

- id
- practice_session_id
- question_id
- submitted_answer
- correct

## Auth approach

### Phase 1

- Email/password auth
- Backend issues login response
- Frontend stores session token later

### Phase 2

- JWT auth
- Protected API routes
- Refresh token strategy if needed

### Phase 3

- Google login

## API shape

### Auth

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`

### Students

- `GET /api/students`
- `POST /api/students`
- `GET /api/students/{id}`
- `PUT /api/students/{id}`

### Soroban

- `GET /api/soroban/representations`
- `GET /api/soroban/practice-sets`
- `GET /api/soroban/practice-sets/{id}/questions`
- `POST /api/soroban/sessions`
- `POST /api/soroban/sessions/{id}/responses`

### Phonics

- `GET /api/phonics/sounds`
- `GET /api/phonics/tricky-words`

### Progress

- `GET /api/progress/students/{id}`

## Deployment recommendation

### Frontend

- Deploy Flutter Web build to Vercel

### Backend

- Deploy Spring Boot jar to Render / Railway

### Database

- Managed Postgres

## Why PostgreSQL over MySQL here

- Excellent managed hosting options
- Strong schema support
- Great tooling for future analytics and reporting
- Smooth fit for Spring Boot production setups

PostgreSQL is not required because MySQL is bad. It is preferred here mainly for simpler hosting and long-term flexibility.
