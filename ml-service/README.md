# X5 ML Service (STUB)

**ВАЖНО: Это заглушка для будущей реализации ML сервиса.**

Этот сервис возвращает моковые данные для оценки резюме на основе простых эвристик.

## Функциональность (текущая)

- Простое сравнение навыков кандидата с требованиями вакансии
- Базовая оценка опыта работы
- Генерация моковых скоров и reasoning

## Запуск

### Требования

- Python 3.11+
- Poetry

### Установка

```bash
cd ml-service
poetry install
```

### Запуск сервера

```bash
poetry run uvicorn app.main:app --reload --port 8001
```

Сервис будет доступен по адресу: http://localhost:8001

## API

### POST /api/ml/evaluate-resume

Оценка резюме относительно требований вакансии.

**Request:**
```json
{
  "resume": {
    "skills": ["Python", "FastAPI", "PostgreSQL"],
    "experience_years": 1,
    "education": {
      "degree": "Bachelor",
      "field": "Computer Science"
    },
    "projects": []
  },
  "vacancy_requirements": {
    "required_skills": ["Python", "FastAPI"],
    "nice_to_have_skills": ["Docker"],
    "min_experience_years": 0
  }
}
```

**Response:**
```json
{
  "overall_score": 85,
  "breakdown": {
    "skills_match": 90,
    "experience_match": 75,
    "education_match": 100
  },
  "matched_skills": ["python", "fastapi"],
  "missing_skills": [],
  "reasoning": "Кандидат обладает всеми необходимыми навыками. Опыт работы (1 лет) соответствует требованиям."
}
```

## Документация

После запуска сервера документация доступна по адресам:
- Swagger UI: http://localhost:8001/docs
- ReDoc: http://localhost:8001/redoc

## Планы на будущее

В будущем этот сервис будет заменен реальной ML моделью, которая:
- Использует NLP для анализа текста резюме
- Учитывает семантическое сходство навыков
- Анализирует проекты и достижения кандидата
- Предоставляет более детальный reasoning

## Лицензия

Proprietary - X5 Group
