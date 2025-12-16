# X5 Recruitment System - Frontend

Frontend для системы рекрутинга X5 Group, построенный на React и TypeScript.

## Технологический стек

- **Framework**: React 18+
- **Language**: TypeScript
- **Build Tool**: Vite
- **State Management**: React Query (TanStack Query)
- **UI Library**: Tailwind CSS
- **HTTP Client**: Axios
- **Routing**: React Router v6

## Структура проекта

```
frontend/
├── src/
│   ├── features/           # Модули функциональности
│   │   ├── auth/          # Авторизация
│   │   │   ├── components/
│   │   │   ├── hooks/
│   │   │   ├── api/
│   │   │   └── types/
│   │   ├── candidates/    # Функции кандидатов
│   │   │   ├── components/
│   │   │   ├── hooks/
│   │   │   ├── api/
│   │   │   └── types/
│   │   ├── recruiter/     # Функции рекрутера
│   │   │   ├── components/
│   │   │   ├── hooks/
│   │   │   ├── api/
│   │   │   └── types/
│   │   └── shared/        # Общие компоненты
│   │       ├── components/
│   │       └── types/
│   ├── lib/               # Конфигурация библиотек
│   │   ├── axios.ts       # Настройка Axios
│   │   └── queryClient.ts # Настройка React Query
│   ├── routes/            # Настройка роутинга
│   ├── App.tsx
│   └── main.tsx
├── public/
├── package.json
├── tsconfig.json
├── vite.config.ts
└── tailwind.config.js
```

## Установка

### Требования

- Node.js 18+
- npm или yarn

### Шаги установки

1. Установите зависимости:
```bash
cd frontend
npm install
```

2. Создайте файл `.env`:
```bash
cp .env.example .env
# Отредактируйте .env при необходимости
```

3. Запустите сервер разработки:
```bash
npm run dev
```

Приложение будет доступно по адресу: http://localhost:5173

## Доступные команды

### Разработка
```bash
npm run dev
```

### Сборка для продакшена
```bash
npm run build
```

### Предпросмотр продакшен сборки
```bash
npm run preview
```

### Линтинг
```bash
npm run lint
```

## Архитектурные принципы

### Feature-based структура

Код организован по функциональным модулям (features), каждый из которых содержит:
- **components/** - React компоненты
- **hooks/** - Кастомные React хуки
- **api/** - API запросы через axios
- **types/** - TypeScript типы и интерфейсы

### State Management

- **Серверное состояние**: React Query (TanStack Query)
- **Локальное состояние**: React useState/useReducer
- **Глобальное состояние**: Context API (при необходимости)

### API Requests

Все API запросы проходят через настроенный axios instance из `lib/axios.ts`:
- Автоматическое добавление JWT токена
- Перехват 401 ошибок и редирект на логин
- Централизованная обработка ошибок

### Типизация

Полная типизация TypeScript для:
- API запросов и ответов
- Props компонентов
- State и Context
- Utility functions

## Переменные окружения

См. файл `.env.example` для списка всех доступных переменных окружения.

## Лицензия

Proprietary - X5 Group
