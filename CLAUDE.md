# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Обзор проекта

X5 Recruitment System - система автоматизации рекрутинга для программы стажировок X5 Group. Упрощает процесс подачи заявок кандидатами, обеспечивает AI-оценку резюме и автоматизирует коммуникацию между кандидатами, рекрутерами и нанимающими менеджерами.

## Технологический стек

**Backend:** Python 3.11+, FastAPI 0.108+, SQLAlchemy 2.0 (async), PostgreSQL 15+, Redis, Celery, Alembic, Pydantic v2, JWT (PyJWT), bcrypt, httpx (async), python-telegram-bot 20+

**Frontend:** React 18+, TypeScript, Vite, TanStack Query (React Query), Tailwind CSS, Axios, React Router v6, React Hook Form + Zod (планируется)

**ML Service:** Заглушка на FastAPI с моковой логикой оценки - реальная ML реализация не входит в текущий этап

**Инфраструктура:** Docker + Docker Compose для локальной разработки, Poetry для управления зависимостями

## Принципы разработки

### Стандарты качества кода
- **Чистая архитектура**: Модульный монолит с четким разделением ответственности
- **SOLID принципы**: Каждый модуль следует принципу единственной ответственности
- **Типобезопасность**: Полные type hints для всех функций и методов
- **DRY**: Никакого дублирования кода, общая логика в утилитах
- **Явное лучше неявного**: Понятные названия, никаких магических значений
- **Современный Python**: Использование фич Python 3.11+ (structural pattern matching, новые type hints)

### Документация
- Docstrings для всех публичных функций (Google style)
- README.md для каждого модуля
- API документация через OpenAPI/Swagger

### Чеклист качества
Каждый коммит должен содержать:
- Type hints на всех функциях
- Docstrings для публичных API
- Нет дублирования кода
- Правильная обработка ошибок (никаких голых `except:`)
- Никаких закомментированного кода

### Правила архитектуры
- Сервисы не обращаются к repositories других сервисов напрямую
- Модели содержат только данные, без бизнес-логики
- Роутеры тонкие, делегируют работу сервисам
- Нет циклических зависимостей
- Используется dependency injection через FastAPI Depends

### Правила безопасности
- Никогда не коммитим `.env` файлы
- Все пароли хешируются через bcrypt
- JWT токены истекают (30 минут по умолчанию)
- SQL injection защищен (используем ORM, без raw SQL)
- CORS правильно настроен

## Настройка окружения разработки

### Инфраструктура
```bash
# Запуск PostgreSQL (порт 5432) и Redis (порт 6379)
docker-compose up -d
```

### Backend
```bash
cd backend
poetry install
cp .env.example .env  # Установить SECRET_KEY в .env
poetry run alembic upgrade head
poetry run uvicorn app.main:app --reload
# API: http://localhost:8000
# Документация: http://localhost:8000/api/docs
```

### ML Service (опционально)
```bash
cd ml-service
poetry install
cp .env.example .env
poetry run uvicorn app.main:app --reload --port 8001
```

### Frontend
```bash
cd frontend
npm install
cp .env.example .env
npm run dev
# Приложение: http://localhost:5173
```

## Основные команды

### Backend
```bash
# Создание миграции
cd backend
poetry run alembic revision --autogenerate -m "описание"

# Применение миграций
poetry run alembic upgrade head

# Откат миграции
poetry run alembic downgrade -1

# Запуск тестов
poetry run pytest
```

### Frontend
```bash
cd frontend
npm run dev          # Сервер разработки
npm run build        # Продакшен сборка
npm run preview      # Предпросмотр продакшен сборки
npm run lint         # Запуск ESLint
```

## Архитектура

### Backend: Модульный монолит

Бэкенд организован в доменные модули в `backend/app/modules/`:
- **candidates** - Управление кандидатами и резюме (Candidate, Resume, QuizAttempt)
- **vacancies** - Управление вакансиями, треками, командами (Vacancy, Track, Team)
- **assessment** - Квизы и AI-оценка резюме (VacancyAssessment, Quiz, QuizQuestion)
- **recruitment** - Воронка найма и интервью (Application, VacancyApplication, Interview)
- **notifications** - Система уведомлений (Notification, шаблоны сообщений)
- **telegram** - Интеграция с Telegram ботами (структура готова, обработчики - заглушки)

Каждый модуль следует структуре:
- `models.py` - SQLAlchemy ORM модели
- `schemas.py` - Pydantic схемы валидации
- `router.py` - FastAPI endpoints
- `service.py` - Бизнес-логика
- `repository.py` - Операции с БД
- `dependencies.py` - FastAPI dependencies (опционально)

**Важно:** Модули сейчас в виде скелета. Требуется реализация моделей и роутеров.

### Структура базы данных

**⚠️ КРИТИЧНО:** Схема БД частично реализована, но может требовать доработки.

Основные таблицы:
- **users** - Пользователи (id, email, password_hash, role: candidate/recruiter/hiring_manager, telegram_id)
- **candidates** - Профили кандидатов (user_id FK, full_name, phone, location, timezone)
- **tracks** - Треки/направления (name, description, is_active)
- **teams** - Команды (name, hiring_manager_id FK)
- **vacancies** - Вакансии (track_id FK, team_id FK, requirements JSONB, is_open)
- **resumes** - Резюме (candidate_id FK, education JSONB, experience JSONB, skills JSONB, portfolio_links JSONB)
- **quizzes** - Квизы для треков (track_id FK, is_active)
- **quiz_questions** - Вопросы квизов (quiz_id FK, question_text, options JSONB, correct_answer JSONB, difficulty)
- **quiz_attempts** - Попытки прохождения квиза (candidate_id FK, quiz_id FK, answers JSONB, score)
- **applications** - Общие заявки кандидатов (candidate_id FK, resume_id FK, quiz_attempt_id FK, status)
- **vacancy_applications** - Заявки на конкретные вакансии (application_id FK, vacancy_id FK, assessment_id FK, status)
- **vacancy_assessments** - AI-оценки резюме (resume_id FK, vacancy_id FK, overall_score, breakdown JSONB, reasoning)
- **interviews** - Интервью (vacancy_application_id FK, scheduled_at, candidate_confirmed, hm_confirmed, hm_feedback JSONB, status)
- **notifications** - Уведомления (user_id FK, type: telegram/email, template_name, payload JSONB, status)

**Важные индексы:**
- users.email (unique), users.telegram_id (unique partial)
- applications.candidate_id
- vacancy_applications.application_id, vacancy_applications.vacancy_id
- vacancy_assessments (resume_id, vacancy_id) - композитный

**Открытые вопросы по БД:**
- JSONB vs нормализация для education/experience/skills?
- Стратегия удаления данных (soft delete vs hard delete)?

### Ядро Backend (`backend/app/core/`)
- `config.py` - Конфигурация через Pydantic Settings (загрузка из .env)
- `database.py` - Управление async SQLAlchemy сессиями
- `security.py` - Работа с JWT токенами и хэширование паролей
- `dependencies.py` - Dependency injection для FastAPI
- `exceptions.py` - Кастомные исключения приложения

### Паттерн Dependency Injection

Используйте типизированные зависимости для сессий БД и аутентификации:

```python
from app.core.dependencies import DBSession, CurrentUserId

@router.get("/me")
async def get_current_user(db: DBSession, user_id: CurrentUserId):
    # user_id автоматически извлекается из JWT
    # db - async сессия базы данных
    pass
```

### Frontend: Архитектура по фичам (Feature-based)

Фронтенд организован по фичам в `frontend/src/features/`:
- **auth** - Аутентификация и регистрация
- **candidates** - Функционал для кандидатов
- **recruiter** - Функционал для рекрутеров
- **shared** - Общие компоненты и типы

Каждая фича содержит:
- `components/` - React компоненты
- `hooks/` - Кастомные React хуки
- `api/` - API запросы через axios
- `types/` - TypeScript интерфейсы

**Управление состоянием:**
- Серверное состояние: React Query (TanStack Query)
- Локальное состояние: React useState/useReducer
- Глобальное состояние: Context API (при необходимости)

**Интеграция с API:**
- Все запросы идут через настроенный axios instance (`lib/axios.ts`)
- Автоматическое добавление JWT токена
- Централизованная обработка ошибок с редиректом на 401

### Миграции базы данных

Настройка Alembic:
- Расположение миграций: `backend/app/migrations/`
- Script location определен в `alembic.ini`
- URL базы данных из переменной окружения `DATABASE_URL`
- Всегда запускайте `alembic upgrade head` после получения новых миграций

### ML Service (текущее состояние)

ML сервис - это **заглушка**, возвращающая моковые оценки на основе простых эвристик:
- Базовое сопоставление навыков между резюме и вакансией
- Сравнение опыта работы
- Моковые оценки
- В будущем планируется замена на реальную NLP/ML модель

## Переменные окружения

**Backend** (`.env` в backend/):
- `DATABASE_URL` - Строка подключения PostgreSQL
- `SECRET_KEY` - Ключ для подписи JWT (ОБЯЗАТЕЛЬНО)
- `REDIS_URL` - Строка подключения Redis
- `ML_SERVICE_URL` - Адрес ML сервиса
- `TELEGRAM_BOT_TOKEN_CANDIDATE` - Токен бота для кандидатов
- `TELEGRAM_BOT_TOKEN_HM` - Токен бота для нанимающих менеджеров
- `FRONTEND_URL` - Разрешенный origin для CORS

**Frontend** (`.env` в frontend/):
- Конфигурация API endpoint (см. `.env.example`)

## API Endpoints

### Авторизация (`/api/auth`)
- `POST /api/auth/register` - Регистрация нового пользователя
- `POST /api/auth/login` - Вход (возвращает JWT)
- `POST /api/auth/refresh` - Обновление токена (если реализовано)
- `GET /api/auth/me` - Получить текущего пользователя

### Кандидаты (`/api/candidates`)
- `POST /api/candidates/resume` - Создать/обновить резюме
- `GET /api/candidates/me` - Получить профиль кандидата
- `GET /api/candidates/applications` - Получить мои заявки со статусами
- `GET /api/tracks` - Список доступных треков

### Квиз (`/api/quiz`)
- `GET /api/quiz/{track_id}` - Получить квиз для трека
- `POST /api/quiz/submit` - Отправить ответы на квиз

### Рекрутинг (`/api/recruitment`) - только для рекрутеров
- `GET /api/recruitment/applications` - Список заявок с фильтрами
- `GET /api/recruitment/applications/{id}` - Детали заявки с оценками
- `POST /api/recruitment/applications/{id}/screen` - Отметить скрининг как завершенный
- `POST /api/recruitment/applications/{id}/send-to-hm` - Отправить нанимающему менеджеру
- `POST /api/recruitment/interviews/{id}/schedule` - Назначить интервью

### Вакансии (`/api/vacancies`) - только для рекрутеров
- `POST /api/vacancies` - Создать вакансию
- `GET /api/vacancies` - Список вакансий
- `PUT /api/vacancies/{id}` - Обновить вакансию
- `DELETE /api/vacancies/{id}` - Закрыть вакансию

### Оценка (`/api/assessment`) - внутреннее
- `POST /api/assessment/evaluate` - Запустить оценку резюме

### ML Service (`/api/ml`)
- `POST /api/ml/evaluate-resume` - Оценка резюме (ЗАГЛУШКА, возвращает моковые данные)

## Статус проекта

**Текущий этап:** Инициализация завершена, основная структура готова

**Сделано:**
- ✅ Структура проектов создана
- ✅ Poetry и npm зависимости установлены
- ✅ Docker Compose настроен (PostgreSQL + Redis)
- ✅ Базовая конфигурация (config, database, security)
- ✅ Alembic настроен, первая миграция создана
- ✅ ML сервис (заглушка) создан и возвращает моковые оценки
- ✅ Frontend структура создана

**Требует реализации:**
- Модели SQLAlchemy для всех модулей
- Роутеры и сервисы для бизнес-логики
- Frontend компоненты и интеграция с API

**НЕ реализуется на текущем этапе:**
- ❌ Реальный ML сервис (только заглушка)
- ❌ Telegram бот обработчики (только структура)
- ❌ Тесты (будут добавлены позже)
- ❌ Линтеры/форматеры (ruff и mypy не используются)

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

## Открытые вопросы

- [ ] **КРИТИЧНО**: Финальная структура БД - JSONB vs нормализация для education/experience/skills?
- [ ] Один Telegram бот или два (кандидаты + HM)? (для будущей реализации)
- [ ] Нужна ли реализация refresh token?
- [ ] Email уведомления как fallback к Telegram? (для будущей реализации)

## Важные замечания

- Проект использует модульный монолит для поддержания хорошего разделения ответственности при простоте развертывания
- Backend полностью async (FastAPI + SQLAlchemy 2.0 async)
- Frontend использует React Query для серверного состояния
- Все роутеры должны быть зарегистрированы в [backend/app/main.py](backend/app/main.py:67-72) (см. TODO комментарии)
