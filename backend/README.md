# X5 Recruitment System - Backend

Бэкенд системы рекрутинга X5 Group, построенный на FastAPI.

## Технологический стек

- **Python**: 3.11+
- **Framework**: FastAPI
- **ORM**: SQLAlchemy 2.0 (async)
- **База данных**: PostgreSQL 15+
- **Миграции**: Alembic
- **Валидация**: Pydantic v2
- **Авторизация**: JWT
- **Управление зависимостями**: Poetry

## Структура проекта

```
backend/
├── app/
│   ├── modules/          # Модули приложения
│   │   ├── candidates/   # Модуль кандидатов
│   │   ├── vacancies/    # Модуль вакансий
│   │   ├── assessment/   # Модуль оценки
│   │   ├── recruitment/  # Модуль рекрутинга
│   │   ├── notifications/# Модуль уведомлений
│   │   └── telegram/     # Telegram бот
│   ├── core/             # Ядро приложения
│   │   ├── config.py     # Конфигурация
│   │   ├── database.py   # Настройка БД
│   │   ├── security.py   # Безопасность
│   │   └── exceptions.py # Исключения
│   ├── shared/           # Общие компоненты
│   │   ├── models.py     # Базовые модели
│   │   ├── schemas.py    # Общие схемы
│   │   ├── enums.py      # Enums
│   │   └── utils.py      # Утилиты
│   ├── migrations/       # Миграции Alembic
│   └── main.py           # Точка входа
├── pyproject.toml        # Зависимости Poetry
└── alembic.ini           # Конфигурация Alembic
```

## Установка

### Требования

- Python 3.11+
- Poetry
- PostgreSQL 15+ (или Docker)
- Redis (или Docker)

### Шаги установки

1. Установите зависимости:
```bash
cd backend
poetry install
```

2. Запустите PostgreSQL и Redis:
```bash
cd ..
docker-compose up -d
```

3. Создайте файл `.env`:
```bash
cp .env.example .env
# Отредактируйте .env и установите SECRET_KEY
```

4. Запустите миграции:
```bash
poetry run alembic upgrade head
```

5. Запустите сервер разработки:
```bash
poetry run uvicorn app.main:app --reload
```

API будет доступен по адресу: http://localhost:8000

## API документация

После запуска сервера документация доступна по адресам:
- Swagger UI: http://localhost:8000/api/docs
- ReDoc: http://localhost:8000/api/redoc

## Разработка

### Создание новой миграции

```bash
poetry run alembic revision --autogenerate -m "Описание миграции"
```

### Применение миграций

```bash
poetry run alembic upgrade head
```

### Откат миграции

```bash
poetry run alembic downgrade -1
```

## Архитектурные принципы

### Модульная структура

Каждый модуль следует структуре:
- `models.py` - SQLAlchemy модели
- `schemas.py` - Pydantic схемы для валидации
- `router.py` - FastAPI endpoints
- `service.py` - Бизнес-логика
- `repository.py` - Операции с БД
- `dependencies.py` - FastAPI dependencies (опционально)

### Dependency Injection

Используйте FastAPI Depends для инъекции зависимостей:

```python
from app.core.dependencies import DBSession, CurrentUserId

@router.get("/me")
async def get_current_user(
    db: DBSession,
    user_id: CurrentUserId,
):
    # user_id автоматически извлекается из JWT
    # db - сессия базы данных
    pass
```

### Обработка ошибок

Используйте кастомные исключения из `app.core.exceptions`:

```python
from app.core.exceptions import NotFoundException

if not user:
    raise NotFoundException("User not found")
```

## Команды для разработки

### Запуск тестов

```bash
poetry run pytest
```

### Проверка типов (будущее)

```bash
poetry run mypy app/
```

## Переменные окружения

См. файл `.env.example` для списка всех доступных переменных окружения.

## Лицензия

Proprietary - X5 Group
