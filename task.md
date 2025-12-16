# Система рекрутинга X5 Group - Начальная настройка проекта

## Обзор проекта

Система автоматизации рекрутинга для программы стажировок X5 Group. Система упрощает процесс подачи заявок кандидатами, обеспечивает AI-оценку резюме и автоматизирует коммуникацию между кандидатами, рекрутерами и нанимающими менеджерами.

## Основные принципы

### Стандарты качества кода
- **Чистая архитектура**: Модульный монолит с четким разделением ответственности
- **SOLID принципы**: Каждый модуль следует принципу единственной ответственности
- **Типобезопасность**: Полные type hints для всех функций и методов
- **DRY**: Никакого дублирования кода, общая логика вынесена в утилиты
- **Явное лучше неявного**: Понятные названия, никаких магических значений
- **Современный Python**: Использование фич Python 3.11+ (structural pattern matching, новые type hints)

### Документация
- Docstrings для всех публичных функций (Google style)
- README.md для каждого модуля
- API документация через OpenAPI/Swagger

## Технологический стек

### Backend
- **Язык**: Python 3.11+
- **Framework**: FastAPI 0.108+
- **ORM**: SQLAlchemy 2.0+ (async)
- **База данных**: PostgreSQL 15+
- **Миграции**: Alembic
- **Валидация**: Pydantic v2
- **Авторизация**: JWT (PyJWT)
- **Пароли**: bcrypt
- **Асинхронные задачи**: Celery + Redis
- **Telegram**: python-telegram-bot 20+
- **HTTP клиент**: httpx (async)

### ML сервис
- **Framework**: FastAPI
- **Примечание**: Реализация ML сервиса не входит в текущий этап. Необходимо создать заглушку для будущей интеграции.

### Frontend
- **Framework**: React 18+ с TypeScript
- **State Management**: React Query (TanStack Query)
- **UI библиотека**: Tailwind CSS + shadcn/ui
- **Формы**: React Hook Form + Zod
- **HTTP клиент**: Axios
- **Роутинг**: React Router v6

### Инфраструктура
- **Управление зависимостями**: Poetry
- **Контейнеризация**: Docker + Docker Compose (для локальной разработки)

## Текущее состояние проекта

**ВАЖНО: Проект находится на нулевой стадии.**

На данный момент:
- ❌ Нет структуры директорий
- ❌ Нет базы данных
- ❌ Нет репозитория
- ❌ Нет зависимостей
- ❌ Нет конфигурационных файлов

Есть только пустая папка - абсолютно чистый лист.

## Структура проекта

```
x5-recruitment-system/
├── backend/
│   ├── app/
│   │   ├── modules/
│   │   │   ├── __init__.py
│   │   │   ├── candidates/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── models.py         # Candidate, Resume, QuizAttempt
│   │   │   │   ├── schemas.py        # Pydantic схемы
│   │   │   │   ├── router.py         # API endpoints
│   │   │   │   ├── service.py        # Бизнес-логика
│   │   │   │   ├── repository.py     # Операции с БД
│   │   │   │   └── dependencies.py   # FastAPI dependencies
│   │   │   │
│   │   │   ├── vacancies/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── models.py         # Vacancy, Track, Team
│   │   │   │   ├── schemas.py
│   │   │   │   ├── router.py
│   │   │   │   ├── service.py
│   │   │   │   └── repository.py
│   │   │   │
│   │   │   ├── assessment/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── models.py         # VacancyAssessment, Quiz
│   │   │   │   ├── schemas.py
│   │   │   │   ├── router.py
│   │   │   │   ├── service.py
│   │   │   │   ├── repository.py
│   │   │   │   └── ml_client.py      # Клиент для ML сервиса
│   │   │   │
│   │   │   ├── recruitment/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── models.py         # Application, Interview
│   │   │   │   ├── schemas.py
│   │   │   │   ├── router.py
│   │   │   │   ├── service.py
│   │   │   │   └── repository.py
│   │   │   │
│   │   │   ├── notifications/
│   │   │   │   ├── __init__.py
│   │   │   │   ├── models.py         # Notification
│   │   │   │   ├── schemas.py
│   │   │   │   ├── service.py
│   │   │   │   └── templates.py      # Шаблоны сообщений
│   │   │   │
│   │   │   └── telegram/
│   │   │       ├── __init__.py
│   │   │       ├── bot.py            # Настройка бота
│   │   │       ├── handlers/
│   │   │       │   ├── __init__.py
│   │   │       │   ├── candidate.py  # Обработчики для кандидатов
│   │   │       │   └── hiring_manager.py
│   │   │       ├── keyboards.py      # Telegram клавиатуры
│   │   │       └── states.py         # FSM состояния
│   │   │
│   │   ├── core/
│   │   │   ├── __init__.py
│   │   │   ├── config.py             # Настройки (Pydantic BaseSettings)
│   │   │   ├── database.py           # Async DB сессия
│   │   │   ├── security.py           # JWT, хеширование паролей
│   │   │   ├── dependencies.py       # Глобальные dependencies
│   │   │   └── exceptions.py         # Кастомные исключения
│   │   │
│   │   ├── shared/
│   │   │   ├── __init__.py
│   │   │   ├── models.py             # Базовые модели, User
│   │   │   ├── schemas.py            # Общие схемы
│   │   │   ├── enums.py              # Enums (UserRole, Status и т.д.)
│   │   │   └── utils.py              # Утилиты
│   │   │
│   │   ├── migrations/               # Alembic миграции
│   │   │   └── versions/
│   │   │
│   │   └── main.py                   # Точка входа FastAPI
│   │
│   ├── pyproject.toml                # Poetry зависимости
│   ├── poetry.lock
│   ├── alembic.ini                   # Конфигурация Alembic
│   ├── .env.example
│   └── README.md
│
├── ml-service/                       # ЗАГЛУШКА для будущей реализации
│   ├── app/
│   │   ├── main.py                   # FastAPI приложение (минимальная заглушка)
│   │   ├── schemas.py                # Request/Response модели
│   │   └── config.py
│   ├── pyproject.toml
│   ├── .env.example
│   └── README.md
│
├── frontend/
│   ├── src/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   │   ├── components/
│   │   │   │   │   ├── LoginForm.tsx
│   │   │   │   │   └── RegisterForm.tsx
│   │   │   │   ├── hooks/
│   │   │   │   │   └── useAuth.ts
│   │   │   │   ├── api/
│   │   │   │   │   └── authApi.ts
│   │   │   │   └── types/
│   │   │   │       └── auth.types.ts
│   │   │   │
│   │   │   ├── candidates/
│   │   │   │   ├── components/
│   │   │   │   │   ├── ResumeForm.tsx
│   │   │   │   │   ├── QuizPage.tsx
│   │   │   │   │   └── ApplicationStatus.tsx
│   │   │   │   ├── hooks/
│   │   │   │   ├── api/
│   │   │   │   └── types/
│   │   │   │
│   │   │   ├── recruiter/
│   │   │   │   ├── components/
│   │   │   │   │   ├── ApplicationsList.tsx
│   │   │   │   │   ├── ApplicationDetails.tsx
│   │   │   │   │   └── VacancyForm.tsx
│   │   │   │   ├── hooks/
│   │   │   │   ├── api/
│   │   │   │   └── types/
│   │   │   │
│   │   │   └── shared/
│   │   │       ├── components/
│   │   │       │   ├── Button.tsx
│   │   │       │   ├── Input.tsx
│   │   │       │   └── ...
│   │   │       └── types/
│   │   │
│   │   ├── lib/
│   │   │   ├── axios.ts             # Настройка Axios с interceptors
│   │   │   └── queryClient.ts       # Настройка React Query
│   │   │
│   │   ├── routes/
│   │   │   └── index.tsx            # Настройка React Router
│   │   │
│   │   ├── App.tsx
│   │   ├── main.tsx
│   │   └── vite-env.d.ts
│   │
│   ├── public/
│   ├── package.json
│   ├── tsconfig.json
│   ├── vite.config.ts
│   ├── tailwind.config.js
│   ├── .env.example
│   └── README.md
│
├── docker-compose.yml                # Настройка локальной разработки
├── .gitignore
└── README.md                         # Главный README проекта
```

## Схема базы данных

**⚠️ ВАЖНО: Структура БД требует детальной проработки!**

Представленная ниже схема является предварительной и может значительно измениться. Перед началом реализации необходимо:
1. Детально проработать все связи между таблицами
2. Определить оптимальную структуру JSONB полей
3. Решить вопросы нормализации (особенно для `education`, `experience`, `skills`)
4. Продумать индексы для оптимизации частых запросов
5. Определить стратегию удаления данных (soft delete vs hard delete)

### Основные таблицы

**users** (пользователи)
- `id` (PK, UUID)
- `email` (unique, indexed)
- `password_hash`
- `role` (enum: candidate, recruiter, hiring_manager)
- `telegram_id` (nullable, unique)
- `is_active` (boolean)
- `created_at`, `updated_at`

**candidates** (кандидаты)
- `id` (PK, UUID)
- `user_id` (FK → users, unique)
- `full_name`
- `phone`
- `location`
- `timezone`
- `created_at`, `updated_at`

**tracks** (треки/направления)
- `id` (PK, int)
- `name` (например, "Python Backend", "Frontend")
- `description`
- `is_active`

**teams** (команды)
- `id` (PK, int)
- `name`
- `hiring_manager_id` (FK → users)

**vacancies** (вакансии)
- `id` (PK, int)
- `track_id` (FK → tracks)
- `team_id` (FK → teams)
- `requirements` (JSONB)
- `is_open`
- `created_at`, `updated_at`

**resumes** (резюме)
- `id` (PK, int)
- `candidate_id` (FK → candidates)
- `education` (JSONB)
- `experience` (JSONB)
- `skills` (JSONB array)
- `portfolio_links` (JSONB array)
- `created_at`, `updated_at`

**quizzes** (квизы)
- `id` (PK, int)
- `track_id` (FK → tracks)
- `is_active`

**quiz_questions** (вопросы квиза)
- `id` (PK, int)
- `quiz_id` (FK → quizzes)
- `question_text`
- `question_type` (enum: single_choice, multiple_choice)
- `options` (JSONB)
- `correct_answer` (JSONB)
- `difficulty` (int 1-5)

**quiz_attempts** (попытки прохождения квиза)
- `id` (PK, int)
- `candidate_id` (FK → candidates)
- `quiz_id` (FK → quizzes)
- `answers` (JSONB)
- `score` (float 0-100)
- `completed_at`

**applications** (заявки)
- `id` (PK, int)
- `candidate_id` (FK → candidates)
- `resume_id` (FK → resumes)
- `quiz_attempt_id` (FK → quiz_attempts)
- `status` (enum: submitted, screening, interviewing, rejected, hired)
- `created_at`, `updated_at`

**vacancy_applications** (заявки на вакансии)
- `id` (PK, int)
- `application_id` (FK → applications)
- `vacancy_id` (FK → vacancies)
- `assessment_id` (FK → vacancy_assessments, nullable)
- `recruiter_notes` (text)
- `status` (enum: pending, sent_to_hm, hm_approved, hm_rejected, interview_scheduled, interviewed, offer, rejected)
- `created_at`, `updated_at`

**vacancy_assessments** (оценки резюме)
- `id` (PK, int)
- `resume_id` (FK → resumes)
- `vacancy_id` (FK → vacancies)
- `overall_score` (float 0-100)
- `breakdown` (JSONB: skills_match, experience_match и т.д.)
- `reasoning` (text)
- `created_at`

**interviews** (интервью)
- `id` (PK, int)
- `vacancy_application_id` (FK → vacancy_applications)
- `scheduled_at` (timestamptz)
- `candidate_confirmed` (boolean)
- `hm_confirmed` (boolean)
- `hm_feedback` (JSONB: rating, notes)
- `status` (enum: pending, confirmed, completed, cancelled)
- `created_at`, `updated_at`

**notifications** (уведомления)
- `id` (PK, int)
- `user_id` (FK → users)
- `type` (enum: telegram, email)
- `template_name`
- `payload` (JSONB)
- `status` (enum: pending, sent, failed)
- `sent_at`
- `created_at`

### Индексы
- `users.email` (unique)
- `users.telegram_id` (unique, partial where not null)
- `applications.candidate_id`
- `vacancy_applications.application_id`
- `vacancy_applications.vacancy_id`
- `vacancy_assessments.resume_id, vacancy_id` (композитный)

## Структура API

### Авторизация
- `POST /api/auth/register` - Регистрация нового пользователя
- `POST /api/auth/login` - Вход (возвращает JWT)
- `POST /api/auth/refresh` - Обновление токена
- `GET /api/auth/me` - Получить текущего пользователя

### Кандидаты
- `POST /api/candidates/resume` - Создать/обновить резюме
- `GET /api/candidates/me` - Получить профиль кандидата
- `GET /api/candidates/applications` - Получить мои заявки со статусами
- `GET /api/tracks` - Список доступных треков

### Квиз
- `GET /api/quiz/{track_id}` - Получить квиз для трека
- `POST /api/quiz/submit` - Отправить ответы на квиз

### Рекрутинг (только для рекрутеров)
- `GET /api/recruitment/applications` - Список заявок с фильтрами
- `GET /api/recruitment/applications/{id}` - Детали заявки с оценками
- `POST /api/recruitment/applications/{id}/screen` - Отметить скрининг как завершенный
- `POST /api/recruitment/applications/{id}/send-to-hm` - Отправить нанимающему менеджеру
- `POST /api/recruitment/interviews/{id}/schedule` - Назначить интервью

### Вакансии (только для рекрутеров)
- `POST /api/vacancies` - Создать вакансию
- `GET /api/vacancies` - Список вакансий
- `PUT /api/vacancies/{id}` - Обновить вакансию
- `DELETE /api/vacancies/{id}` - Закрыть вакансию

### Оценка (внутреннее)
- `POST /api/assessment/evaluate` - Запустить оценку резюме

## API ML сервиса

**Примечание**: ML сервис на данном этапе НЕ реализуется. Ниже представлен контракт для будущей интеграции.

### Endpoints
- `POST /api/ml/evaluate-resume` (ЗАГЛУШКА)

**Запрос:**
```json
{
  "resume": {
    "skills": ["Python", "FastAPI", "PostgreSQL"],
    "experience_years": 1,
    "education": {
      "degree": "Bachelor",
      "field": "Computer Science"
    },
    "projects": [...]
  },
  "vacancy_requirements": {
    "required_skills": ["Python", "FastAPI"],
    "nice_to_have_skills": ["Docker"],
    "min_experience_years": 0
  }
}
```

**Ответ (заглушка может возвращать моковые данные):**
```json
{
  "overall_score": 85,
  "breakdown": {
    "skills_match": 90,
    "experience_match": 75,
    "education_match": 100
  },
  "matched_skills": ["Python", "FastAPI"],
  "missing_skills": ["Docker"],
  "reasoning": "Кандидат демонстрирует сильную базу..."
}
```

## Конфигурация окружения

### Backend `.env`
```env
# База данных
DATABASE_URL=postgresql+asyncpg://postgres:postgres@localhost:5432/recruitment_db

# Безопасность
SECRET_KEY=your-secret-key-min-32-chars
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Telegram
TELEGRAM_BOT_TOKEN_CANDIDATE=your_candidate_bot_token  # Пока не используется
TELEGRAM_BOT_TOKEN_HM=your_hm_bot_token  # Пока не используется

# ML сервис
ML_SERVICE_URL=http://localhost:8001

# Redis (для Celery)
REDIS_URL=redis://localhost:6379/0

# CORS
FRONTEND_URL=http://localhost:5173
```

### ML сервис `.env`
```env
# Пока заглушка, реальные ключи не требуются
ML_SERVICE_PORT=8001
```

### Frontend `.env`
```env
VITE_API_URL=http://localhost:8000
```

## Настройка Poetry

### Backend `pyproject.toml`
```toml
[tool.poetry]
name = "x5-recruitment-backend"
version = "0.1.0"
description = "Бэкенд системы рекрутинга X5 Group"
authors = ["Ваша команда"]
python = "^3.11"

[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.108.0"
uvicorn = {extras = ["standard"], version = "^0.25.0"}
sqlalchemy = "^2.0.23"
asyncpg = "^0.29.0"
alembic = "^1.13.0"
pydantic = {extras = ["email"], version = "^2.5.0"}
pydantic-settings = "^2.1.0"
pyjwt = "^2.8.0"
passlib = {extras = ["bcrypt"], version = "^1.7.4"}
python-multipart = "^0.0.6"
httpx = "^0.25.2"
redis = "^5.0.1"
celery = "^5.3.4"
python-telegram-bot = "^20.7"

[tool.poetry.group.dev.dependencies]
pytest = "^7.4.3"
pytest-asyncio = "^0.23.2"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

## Этапы реализации

### Этап 0: Проектирование БД (КРИТИЧНО - СДЕЛАТЬ ПЕРВЫМ)
**Перед написанием кода необходимо детально проработать структуру базы данных:**
1. Определить все таблицы и их связи
2. Решить: хранить ли `education`, `experience`, `skills` в JSONB или создать отдельные таблицы?
3. Продумать индексы для оптимизации запросов
4. Определить стратегию каскадного удаления
5. Создать детальную ER-диаграмму
6. Согласовать с командой финальную схему

**Результат этапа**: Утвержденная схема БД, готовая к реализации

### Этап 1: Фундамент (День 1)
1. **Настройка структуры проекта** - Создать все директории и базовые файлы
2. **Настройка Poetry** - Установить зависимости, настроить dev инструменты
3. **Настройка БД** - Docker Compose с PostgreSQL, создать базовые модели
4. **Настройка FastAPI** - Главное приложение, регистрация роутеров, CORS
5. **Реализация core** - Config, database session, security утилиты
6. **Настройка Alembic** - Начальная миграция с моделью User

### Этап 2: Основные модули (День 2-3)
7. **Модуль Auth** - Регистрация, вход, JWT
8. **Модуль Candidates** - Создание резюме, управление профилем
9. **Модуль Vacancies** - CRUD для треков, команд, вакансий
10. **Модуль Assessment** - Логика квиза, скелет ML клиента (заглушка)

### Этап 3: Бизнес-логика (День 4-5)
11. **Модуль Recruitment** - Воронка заявок, скрининг
12. **ML сервис** - Создать заглушку с моковыми ответами
13. **Модуль Notifications** - Система шаблонов, логика отправки
14. **Telegram бот** - Создать структуру модуля (заглушка)

### Этап 4: Интеграция (День 6)
15. **Связка всех модулей** - Сквозной workflow (без Telegram и ML на первом этапе)
16. **Frontend** - Базовый UI для всех ролей

### Этап 5: Полировка (День 7)
17. **Исправление багов**
18. **Документация**
19. **Подготовка демо**

## Чеклист качества кода

### Каждый PR должен содержать:
- [ ] Type hints на всех функциях
- [ ] Docstrings для публичных API
- [ ] Нет дублирования кода
- [ ] Правильная обработка ошибок (никаких голых `except:`)
- [ ] Никаких закомментированного кода

### Правила архитектуры:
- [ ] Сервисы не обращаются к repositories других сервисов напрямую
- [ ] Модели содержат только данные, без бизнес-логики
- [ ] Роутеры тонкие, делегируют работу сервисам
- [ ] Нет циклических зависимостей
- [ ] Используется dependency injection через FastAPI Depends

### Правила безопасности:
- [ ] Никогда не коммитим `.env` файлы
- [ ] Все пароли хешируются через bcrypt
- [ ] JWT токены истекают
- [ ] SQL injection защищен (используем ORM, без raw SQL)
- [ ] CORS правильно настроен

## Git Workflow

### Именование веток
- `feature/название-модуля` - Новые фичи
- `fix/описание-проблемы` - Исправления багов
- `refactor/название-компонента` - Рефакторинг

### Commit messages (Conventional Commits)
```
feat(candidates): добавить endpoint создания резюме
fix(auth): исправить проблему с истечением JWT
refactor(assessment): вынести логику подсчета в сервис
docs(readme): обновить инструкции по установке
test(recruitment): добавить integration тесты для скрининга
```

### PR Requirements
- Заголовок описывает что изменилось
- Описание объясняет зачем
- Минимум один approve от члена команды (если возможно)

## Следующие шаги

### Шаг 0: Проектирование базы данных (ПЕРВОСТЕПЕННАЯ ЗАДАЧА)
Перед началом кодирования необходимо детально проработать структуру БД вместе с командой.

### Шаг 1: Инициализация проекта
1. **Создать Git репозиторий**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. **Инициализировать Backend проект**
   ```bash
   mkdir backend
   cd backend
   poetry init --name x5-recruitment-backend --python "^3.11"
   poetry add fastapi uvicorn sqlalchemy asyncpg alembic pydantic pydantic-settings pyjwt passlib python-multipart httpx redis celery python-telegram-bot
   poetry add --group dev pytest pytest-asyncio
   ```

3. **Инициализировать ML сервис (заглушка)**
   ```bash
   mkdir ml-service
   cd ml-service
   poetry init --name x5-ml-service --python "^3.11"
   poetry add fastapi uvicorn pydantic
   ```

4. **Инициализировать Frontend**
   ```bash
   npm create vite@latest frontend -- --template react-ts
   cd frontend
   npm install
   npm install axios @tanstack/react-query react-router-dom
   npm install -D tailwindcss postcss autoprefixer
   npx tailwindcss init -p
   ```

### Шаг 2: Настройка Docker Compose
Создать `docker-compose.yml` для PostgreSQL и Redis

### Шаг 3: Создание структуры директорий
Создать все папки и файлы согласно структуре проекта

### Шаг 4: Финализация схемы БД
После проработки создать модели SQLAlchemy

### Шаг 5: Настройка Alembic
Инициализировать Alembic и создать первую миграцию

### Шаг 6: Реализация модуля auth
Начать с авторизации как фундамента

### Шаг 7: Распределение работы
Распределить модули между членами команды

---

## Что НЕ реализуется на текущем этапе

- ❌ **ML сервис** - только заглушка с моковыми ответами
- ❌ **Telegram бот** - только структура модуля, без реальной реализации обработчиков
- ❌ **Тесты** - будут добавлены позже при необходимости
- ❌ **Линтеры/форматеры** - ruff и mypy не используются

## Вопросы для решения

- [ ] **КРИТИЧНО**: Финальная структура БД - JSONB vs нормализация для education/experience/skills?
- [ ] Один Telegram бот или два (кандидаты + HM)? (для будущей реализации)
- [ ] Нужна ли реализация refresh token?
- [ ] Email уведомления как fallback к Telegram? (для будущей реализации)