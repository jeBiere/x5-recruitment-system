# X5 Recruitment System

Система автоматизации рекрутинга для программы стажировок X5 Group. Система упрощает процесс подачи заявок кандидатами, обеспечивает AI-оценку резюме и автоматизирует коммуникацию между кандидатами, рекрутерами и нанимающими менеджерами.

## Структура проекта

```
x5-recruitment-system/
├── backend/              # FastAPI бэкенд
├── ml-service/           # ML сервис (заглушка)
├── frontend/             # React frontend
├── docker-compose.yml    # Docker конфигурация для разработки
└── README.md             # Этот файл
```

## Технологический стек

### Backend
- Python 3.11+ / FastAPI
- PostgreSQL 15+ / SQLAlchemy 2.0 (async)
- Redis / Celery
- Alembic (миграции)
- JWT авторизация

### ML Service
- Python 3.11+ / FastAPI
- **Текущая версия**: Заглушка с моковыми данными

### Frontend
- React 18+ / TypeScript
- Vite
- TanStack Query (React Query)
- Tailwind CSS
- Axios

## Быстрый старт

### Требования

- Python 3.11+
- Poetry
- Node.js 18+
- Docker и Docker Compose
- Git

### 1. Клонирование репозитория

```bash
git clone <repository-url>
cd bootCamp
```

### 2. Запуск инфраструктуры (PostgreSQL + Redis)

```bash
docker-compose up -d
```

Это запустит:
- PostgreSQL на порту 5432
- Redis на порту 6379

### 3. Настройка Backend

```bash
cd backend

# Установка зависимостей
poetry install

# Создание .env файла
cp .env.example .env
# ВАЖНО: Откройте .env и установите SECRET_KEY

# Применение миграций
poetry run alembic upgrade head

# Запуск сервера
poetry run uvicorn app.main:app --reload
```

Backend будет доступен по адресу: http://localhost:8000
API документация: http://localhost:8000/api/docs

### 4. Настройка ML сервиса (опционально)

```bash
cd ml-service

# Установка зависимостей
poetry install

# Создание .env файла
cp .env.example .env

# Запуск сервера
poetry run uvicorn app.main:app --reload --port 8001
```

ML сервис будет доступен по адресу: http://localhost:8001

### 5. Настройка Frontend

```bash
cd frontend

# Установка зависимостей
npm install

# Создание .env файла
cp .env.example .env

# Запуск сервера разработки
npm run dev
```

Frontend будет доступен по адресу: http://localhost:5173

## Архитектура

### Backend: Модульный монолит

Проект организован по модулям (модульный монолит):

- **candidates**: Управление кандидатами и резюме
- **vacancies**: Управление вакансиями, треками, командами
- **assessment**: Квизы и AI-оценка резюме
- **recruitment**: Воронка найма, интервью
- **notifications**: Система уведомлений
- **telegram**: Telegram бот (структура)

Каждый модуль следует паттерну:
- `models.py` - SQLAlchemy модели
- `schemas.py` - Pydantic схемы
- `router.py` - API endpoints
- `service.py` - Бизнес-логика
- `repository.py` - Работа с БД

### Frontend: Feature-based

Приложение организовано по фичам (features):
- `auth` - Авторизация и регистрация
- `candidates` - Функции кандидатов
- `recruiter` - Функции рекрутера
- `shared` - Общие компоненты

## Разработка

### Backend

#### Создание миграции

```bash
cd backend
poetry run alembic revision --autogenerate -m "Описание изменений"
poetry run alembic upgrade head
```

#### Запуск тестов

```bash
cd backend
poetry run pytest
```

### Frontend

#### Запуск линтера

```bash
cd frontend
npm run lint
```

#### Сборка для продакшена

```bash
cd frontend
npm run build
```

## API Endpoints (текущие)

### Backend
- `GET /` - Root endpoint
- `GET /health` - Health check
- `GET /api/docs` - Swagger UI
- `GET /api/redoc` - ReDoc

### ML Service
- `GET /` - Service info
- `GET /health` - Health check
- `POST /api/ml/evaluate-resume` - Оценка резюме (заглушка)

## Текущий статус проекта

**Этап 1: Инициализация проекта** ✅

- ✅ Структура проектов создана
- ✅ Poetry и npm зависимости установлены
- ✅ Docker Compose настроен
- ✅ Базовая конфигурация (config, database, security)
- ✅ Alembic настроен
- ✅ ML сервис (заглушка) создан
- ✅ Frontend структура создана

**Следующие шаги**:

1. **Проектирование БД** (Этап 0) - Детально проработать схему базы данных
2. **Создание миграций** - Создать модели SQLAlchemy и первую миграцию
3. **Модуль Auth** - Реализовать регистрацию, логин, JWT
4. **Остальные модули** - По плану из документации

## Документация

Детальная документация доступна в каждом под-проекте:
- [Backend README](backend/README.md)
- [ML Service README](ml-service/README.md)
- [Frontend README](frontend/README.md)

## Лицензия

Proprietary - X5 Group

## Команда

- Backend разработчики
- Frontend разработчики
- ML инженеры
- DevOps

---

**Вопросы?** Обратитесь к документации или создайте issue.
