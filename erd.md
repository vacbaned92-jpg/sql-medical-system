# ERD-диаграмма медицинской системы

```mermaid
erDiagram
    User ||--o{ DoctorProfile : "имеет (1:1 или 1:?)"
    User ||--o{ PatientProfile : "имеет (1:?)"
    DoctorProfile ||--o{ DoctorBranch : "работает в филиалах"
    ClinicBranch ||--o{ DoctorBranch : "где работают врачи"
    DoctorProfile ||--o{ Service : "оказывает услуги"
    DoctorProfile ||--o{ TimeSlot : "доступные слоты"
    ClinicBranch ||--o{ TimeSlot : "в филиале"
    PatientProfile ||--o{ Appointment : "записывается на приём"
    DoctorProfile ||--o{ Appointment : "врач на приёме"
    ClinicBranch ||--o{ Appointment : "филиал приёма"
    Service ||--o{ Appointment : "услуга приёма"
    TimeSlot ||--o{ Appointment : "занятый слот"
    Appointment ||--|| AIQuestionnaire : "анкета ИИ"
    User ||--o{ Notification : "уведомления"

    User {
        SERIAL id PK
        VARCHAR email
        VARCHAR password_hash
        VARCHAR phone
        VARCHAR full_name
        VARCHAR role
        TIMESTAMP created_at
    }

    DoctorProfile {
        SERIAL id PK
        INTEGER user_id FK "уникальный"
        VARCHAR specialization
        TEXT bio
        SMALLINT experience_years
        VARCHAR photo_url
    }

    PatientProfile {
        SERIAL id PK
        INTEGER user_id FK "уникальный"
        DATE date_of_birth
        TEXT address
    }

    ClinicBranch {
        SERIAL id PK
        VARCHAR name
        TEXT address
        NUMERIC lat
        NUMERIC lng
        VARCHAR phone
        TEXT working_hours
    }

    DoctorBranch {
        INTEGER doctor_id PK,FK
        INTEGER branch_id PK,FK
    }

    Service {
        SERIAL id PK
        INTEGER doctor_id FK
        VARCHAR name
        TEXT description
        NUMERIC price
        SMALLINT duration_minutes
    }

    TimeSlot {
        SERIAL id PK
        INTEGER doctor_id FK
        INTEGER branch_id FK
        DATE date
        TIME start_time
        BOOLEAN is_available
    }

    Appointment {
        SERIAL id PK
        INTEGER patient_id FK
        INTEGER doctor_id FK
        INTEGER branch_id FK
        INTEGER service_id FK
        INTEGER slot_id FK
        VARCHAR status
        TEXT notes
    }

    AIQuestionnaire {
        SERIAL id PK
        INTEGER appointment_id FK "уникальный"
        JSONB raw_chat_log
        JSONB extracted_symptoms
        TIMESTAMP created_at
    }

    Notification {
        SERIAL id PK
        INTEGER user_id FK
        INTEGER appointment_id FK
        VARCHAR type
        TEXT message
        BOOLEAN is_read
        TIMESTAMP sent_at
    }
    
## Описание связей:

       СВЯЗЬ                        ТИП СВЯЗИ         Описание
1) User -> DoctorProfile	           1:1 	          Каждый пользователь-врач имеет один профиль врача. FK уникальный
2) User -> PatientProfile	           1:0 	          Пользователь-пациент может иметь один профиль пациента
3) DoctorProfile -> DoctorBranch       1:N 	          Один врач может работать в нескольких филиалах
4) ClinicBranch -> DoctorBranch	       1:N 	          В одном филиале может работать много врачей
5) DoctorProfile -> Service	           1:N 	          Врач может оказывать несколько услуг
6) DoctorProfile -> TimeSlot	       1:N 	          У врача есть много временных слотов
7) ClinicBranch -> TimeSlot	           1:N 	          В филиале есть много слотов
8) PatientProfile -> Appointment       1:N 	          Пациент может записаться на несколько приёмов
9) DoctorProfile -> Appointment	       1:N 	          Врач может иметь много записей
10) ClinicBranch -> Appointment	       1:N 	          В филиале проходит много приёмов
11) Service -> Appointment	           1:N 	          Одна услуга может быть назначена на многих приёмах
12) TimeSlot -> Appointment	           1:1 	          На один слот записывается один приём
13) Appointment -> AIQuestionnaire     1:1 	          Каждый приём может иметь одну анкету ИИ
14) User -> Notification	           1:N 	          Пользователь может получить много уведомлений
15) DoctorProfile <-> ClinicBranch     M:N 	          Реализовано через доп таблицу DoctorBranch

## Вопросы для самопроверки

1. Чем связь 1:N отличается от M:N? Приведите пример каждой из вашего проекта.
- 1:N (один-ко-многим): `User -> Notification`: один пользователь может получить много уведомлений, но каждое уведомление адресовано ровно одному пользователю
-*M:N (многие-ко-многим): `DoctorProfile <-> ClinicBranch`: врач может работать в нескольких филиалах, и в одном филиале работает много врачей
2. Почему связь M:N нельзя реализовать двумя таблицами? Зачем нужна промежуточная?
Потому что в реляционной модели внешний ключ может хранить только одно значение. Промежуточная таблица (`DoctorBranch`) позволяет хранить все комбинации `(doctor_id, branch_id)`, реализуя связь M:N
3. Что будет, если удалить запись, на которую ссылается FK?
Зависит от правила `ON DELETE`: если каскадное удаление то - автоматически удалятся все связанные строки. Если `SET NULL` - в связанной таблице FK станет NULL. А если `RESTRICT` (ну или же без действия) - удаление будет запрещено, пока есть ссылающиеся строки
4. Может ли FK быть NULL? Когда это полезно?
Может. FK со значением NULL означает, что связь не установлена. Это полезно для необязательных связей (например, поле `service_id` в `Appointment` - приём может быть без указания конкретной услуги)