# Сущности системы медицинских записей

## 1. User (Пользователь)

**Описание:** Основная учётная запись. Хранит данные для входа, контактную информацию и роль (пациент, врач, администратор).

### Поля

| Поле          | Тип             | Обязательное | Описание |
|---------------|------------------|--------------|----------|
| id            | SERIAL PRIMARY KEY | Да        | Уникальный идентификатор |
| email         | VARCHAR(255) UNIQUE NOT NULL | Да | Электронная почта |
| password_hash | VARCHAR(255) NOT NULL | Да | Хеш пароля |
| phone         | VARCHAR(20)      | Нет         | Номер телефона |
| full_name     | VARCHAR(150) NOT NULL | Да | Полное имя |
| role          | VARCHAR(20) NOT NULL CHECK (role IN ('patient', 'doctor', 'admin')) | Да | Роль пользователя |
| created_at    | TIMESTAMP DEFAULT CURRENT_TIMESTAMP | Да | Дата регистрации |

---

## 2. DoctorProfile (Профиль врача)

**Описание:** Расширенная информация о враче: специализация, биография, опыт, фото.

### Поля

| Поле             | Тип             | Обязательное | Описание |
|------------------|------------------|--------------|----------|
| id               | SERIAL PRIMARY KEY | Да        | Уникальный идентификатор |
| user_id          | INTEGER UNIQUE REFERENCES "User"(id) ON DELETE CASCADE | Да | Связь с учётной записью |
| specialization   | VARCHAR(100) NOT NULL | Да | Специализация (например, «терапевт») |
| bio              | TEXT             | Нет         | Подробная биография |
| experience_years | SMALLINT         | Нет         | Количество лет опыта |
| photo_url        | VARCHAR(300)     | Нет         | Ссылка на фото профиля |

---

## 3. PatientProfile (Профиль пациента)

**Описание:** Дополнительные данные пациента: дата рождения, адрес.

### Поля

| Поле          | Тип             | Обязательное | Описание |
|---------------|------------------|--------------|----------|
| id            | SERIAL PRIMARY KEY | Да        | Уникальный идентификатор |
| user_id       | INTEGER UNIQUE REFERENCES "User"(id) ON DELETE CASCADE | Да | Связь с учётной записью |
| date_of_birth | DATE             | Нет         | Дата рождения |
| address       | TEXT             | Нет         | Домашний адрес |

---

## 4. ClinicBranch (Филиал клиники)

**Описание:** Информация о филиале: адрес, координаты, контакты, часы работы.

### Поля

| Поле          | Тип             | Обязательное | Описание |
|---------------|------------------|--------------|----------|
| id            | SERIAL PRIMARY KEY | Да        | Уникальный идентификатор |
| name          | VARCHAR(200) NOT NULL | Да | Название филиала |
| address       | TEXT NOT NULL    | Да        | Адрес |
| lat           | NUMERIC(9,6)     | Нет         | Широта (для карты) |
| lng           | NUMERIC(9,6)     | Нет         | Долгота |
| phone         | VARCHAR(20)      | Нет         | Контактный телефон |
| working_hours | TEXT             | Нет         | Часы работы (например, «пн-пт 08:00-20:00») |

---

## 5. DoctorBranch (Связь врача с филиалом)

**Описание:** Таблица «многие ко многим». Определяет, в каких филиалах принимает конкретный врач.

### Поля

| Поле      | Тип             | Обязательное | Описание |
|-----------|------------------|--------------|----------|
| doctor_id | INTEGER REFERENCES "DoctorProfile"(id) ON DELETE CASCADE | Да | Врач |
| branch_id | INTEGER REFERENCES "ClinicBranch"(id) ON DELETE CASCADE | Да | Филиал |
| PRIMARY KEY (doctor_id, branch_id) | | | Составной первичный ключ |

---

## 6. Service (Услуга)

**Описание:** Медицинская услуга, оказываемая врачом (приём, консультация, процедура).

### Поля

| Поле              | Тип             | Обязательное | Описание |
|-------------------|------------------|--------------|----------|
| id                | SERIAL PRIMARY KEY | Да        | Уникальный идентификатор |
| doctor_id         | INTEGER REFERENCES "DoctorProfile"(id) ON DELETE SET NULL | Нет | Врач, оказывающий услугу |
| name              | VARCHAR(200) NOT NULL | Да | Название услуги |
| description       | TEXT             | Нет         | Подробное описание |
| price             | NUMERIC(10,2) NOT NULL | Да | Стоимость в рублях |
| duration_minutes  | SMALLINT NOT NULL | Да | Длительность в минутах |

---

## 7. TimeSlot (Временной слот)

**Описание:** Доступное время для записи у врача в конкретном филиале.

### Поля

| Поле        | Тип             | Обязательное | Описание |
|-------------|------------------|--------------|----------|
| id          | SERIAL PRIMARY KEY | Да        | Уникальный идентификатор |
| doctor_id   | INTEGER REFERENCES "DoctorProfile"(id) ON DELETE CASCADE | Да | Врач |
| branch_id   | INTEGER REFERENCES "ClinicBranch"(id) ON DELETE CASCADE | Да | Филиал |
| date        | DATE NOT NULL    | Да        | Дата приёма |
| start_time  | TIME NOT NULL    | Да        | Время начала |
| is_available| BOOLEAN DEFAULT TRUE | Да   | Свободен ли слот |

---

## 8. Appointment (Запись на приём)

**Описание:** Запись пациента к врачу на определённую услугу и временной слот.

### Поля

| Поле        | Тип             | Обязательное | Описание |
|-------------|------------------|--------------|----------|
| id          | SERIAL PRIMARY KEY | Да        | Уникальный идентификатор |
| patient_id  | INTEGER REFERENCES "PatientProfile"(id) ON DELETE CASCADE | Да | Пациент |
| doctor_id   | INTEGER REFERENCES "DoctorProfile"(id) ON DELETE CASCADE | Да | Врач |
| branch_id   | INTEGER REFERENCES "ClinicBranch"(id) ON DELETE CASCADE | Да | Филиал |
| service_id  | INTEGER REFERENCES "Service"(id) ON DELETE SET NULL | Нет | Услуга |
| slot_id     | INTEGER REFERENCES "TimeSlot"(id) ON DELETE SET NULL | Да | Временной слот |
| status      | VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'arrived', 'completed', 'cancelled')) | Да | Статус записи |
| notes       | TEXT             | Нет         | Дополнительные заметки |

---

## 9. AIQuestionnaire (Анкета ИИ-опроса)

**Описание:** Результаты ИИ-опроса перед приёмом. Связана с приёмом один к одному.

### Поля

| Поле               | Тип             | Обязательное | Описание |
|--------------------|------------------|--------------|----------|
| id                 | SERIAL PRIMARY KEY | Да        | Уникальный идентификатор |
| appointment_id     | INTEGER UNIQUE REFERENCES "Appointment"(id) ON DELETE CASCADE | Да | Связь с приёмом |
| raw_chat_log       | JSONB            | Да        | Полная история чата с ИИ |
| extracted_symptoms | JSONB            | Нет         | Извлечённые симптомы (структурированные) |
| created_at         | TIMESTAMP DEFAULT CURRENT_TIMESTAMP | Да | Дата создания |

---

## 10. Notification (Уведомление)

**Описание:** Уведомления для пользователей (напоминания, подтверждения, изменения статуса).

### Поля

| Поле            | Тип             | Обязательное | Описание |
|-----------------|------------------|--------------|----------|
| id              | SERIAL PRIMARY KEY | Да        | Уникальный идентификатор |
| user_id         | INTEGER REFERENCES "User"(id) ON DELETE CASCADE | Да | Получатель |
| appointment_id  | INTEGER REFERENCES "Appointment"(id) ON DELETE SET NULL | Нет | Связанная запись |
| type            | VARCHAR(30) NOT NULL CHECK (type IN ('reminder', 'confirmation', 'status_change')) | Да | Тип уведомления |
| message         | TEXT NOT NULL    | Да        | Текст уведомления |
| is_read         | BOOLEAN DEFAULT FALSE | Да   | Прочитано ли |
| sent_at         | TIMESTAMP DEFAULT CURRENT_TIMESTAMP | Да | Дата отправки |
-
-
-
-
## Вопросы для самопроверки

### 1. Почему важно указывать WHERE в UPDATE и DELETE?
Без WHERE запрос применится ко всем строкам таблицы, это очень плохо( (например удалятся все записи или все значения поля обновятся)
### 2. Что такое первичный ключ (PRIMARY KEY)? Зачем он нужен?
Первичный ключ - это столбец, который уникально определяет каждую строку таблицы. Он гарантирует уникальность + не может быть NULL. Используется для связей и быстрого поиска
### 3. Приведите пример, когда VARCHAR(20) лучше чем TEXT, и наоборот.
- VARCHAR(20) лучше для коротких ограниченных данных, например для ИНН или номера паспорта
- TEXT же лучше для неограниченного текста: описание или комментарий