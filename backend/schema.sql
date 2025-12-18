--
-- PostgreSQL database dump
--

\restrict WHnWaDEHZXpFHAqBTv6h5FyxL4hE98LuhsbrgTYjdNnBYPcepvd3hOQx5FqqX9d

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: application_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.application_status AS ENUM (
    'SUBMITTED',
    'SCREENING',
    'INTERVIEWING',
    'REJECTED',
    'HIRED'
);


ALTER TYPE public.application_status OWNER TO postgres;

--
-- Name: interview_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.interview_status AS ENUM (
    'PENDING',
    'CONFIRMED',
    'COMPLETED',
    'CANCELLED'
);


ALTER TYPE public.interview_status OWNER TO postgres;

--
-- Name: notification_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notification_status AS ENUM (
    'PENDING',
    'SENT',
    'FAILED'
);


ALTER TYPE public.notification_status OWNER TO postgres;

--
-- Name: notification_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notification_type AS ENUM (
    'TELEGRAM',
    'EMAIL'
);


ALTER TYPE public.notification_type OWNER TO postgres;

--
-- Name: question_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.question_type AS ENUM (
    'SINGLE_CHOICE',
    'MULTIPLE_CHOICE'
);


ALTER TYPE public.question_type OWNER TO postgres;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'CANDIDATE',
    'RECRUITER'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- Name: vacancy_application_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.vacancy_application_status AS ENUM (
    'PENDING',
    'SENT_TO_HM',
    'HM_APPROVED',
    'HM_REJECTED',
    'INTERVIEW_SCHEDULED',
    'INTERVIEWED',
    'OFFER',
    'REJECTED'
);


ALTER TYPE public.vacancy_application_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applications (
    id uuid NOT NULL,
    candidate_id uuid NOT NULL,
    resume_id uuid NOT NULL,
    quiz_attempt_id uuid NOT NULL,
    status public.application_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.applications OWNER TO postgres;

--
-- Name: COLUMN applications.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.applications.id IS 'Уникальный UUID заявки';


--
-- Name: COLUMN applications.candidate_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.applications.candidate_id IS 'Ссылка на кандидата';


--
-- Name: COLUMN applications.resume_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.applications.resume_id IS 'Ссылка на резюме';


--
-- Name: COLUMN applications.quiz_attempt_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.applications.quiz_attempt_id IS 'Ссылка на попытку квиза';


--
-- Name: COLUMN applications.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.applications.status IS 'Общий статус заявки';


--
-- Name: COLUMN applications.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.applications.created_at IS 'Когда заявка была создана';


--
-- Name: COLUMN applications.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.applications.updated_at IS 'Когда заявка последний раз обновлялась';


--
-- Name: candidates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.candidates (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    full_name character varying(255) NOT NULL,
    phone character varying(20),
    location character varying(255),
    timezone character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.candidates OWNER TO postgres;

--
-- Name: COLUMN candidates.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.candidates.id IS 'Уникальный UUID кандидата';


--
-- Name: COLUMN candidates.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.candidates.user_id IS 'Ссылка на пользователя';


--
-- Name: COLUMN candidates.full_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.candidates.full_name IS 'Полное имя кандидата';


--
-- Name: COLUMN candidates.phone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.candidates.phone IS 'Номер телефона';


--
-- Name: COLUMN candidates.location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.candidates.location IS 'Местоположение (город, страна)';


--
-- Name: COLUMN candidates.timezone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.candidates.timezone IS 'Часовой пояс кандидата';


--
-- Name: COLUMN candidates.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.candidates.created_at IS 'Когда профиль был создан';


--
-- Name: COLUMN candidates.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.candidates.updated_at IS 'Когда профиль последний раз обновлялся';


--
-- Name: interviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interviews (
    id uuid NOT NULL,
    vacancy_application_id uuid NOT NULL,
    scheduled_at timestamp with time zone NOT NULL,
    candidate_confirmed boolean NOT NULL,
    hm_confirmed boolean NOT NULL,
    hm_feedback jsonb,
    status public.interview_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.interviews OWNER TO postgres;

--
-- Name: COLUMN interviews.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.interviews.id IS 'Уникальный UUID интервью';


--
-- Name: COLUMN interviews.vacancy_application_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.interviews.vacancy_application_id IS 'Ссылка на заявку на вакансию';


--
-- Name: COLUMN interviews.scheduled_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.interviews.scheduled_at IS 'Запланированное время интервью';


--
-- Name: COLUMN interviews.candidate_confirmed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.interviews.candidate_confirmed IS 'Кандидат подтвердил интервью';


--
-- Name: COLUMN interviews.hm_confirmed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.interviews.hm_confirmed IS 'Нанимающий менеджер подтвердил интервью';


--
-- Name: COLUMN interviews.hm_feedback; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.interviews.hm_feedback IS 'Обратная связь от HM в формате JSONB: {rating, notes}';


--
-- Name: COLUMN interviews.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.interviews.status IS 'Статус интервью';


--
-- Name: COLUMN interviews.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.interviews.created_at IS 'Когда интервью было создано';


--
-- Name: COLUMN interviews.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.interviews.updated_at IS 'Когда интервью последний раз обновлялось';


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    type public.notification_type NOT NULL,
    template_name character varying(255) NOT NULL,
    payload jsonb NOT NULL,
    status public.notification_status NOT NULL,
    sent_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: COLUMN notifications.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.notifications.id IS 'Уникальный UUID уведомления';


--
-- Name: COLUMN notifications.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.notifications.user_id IS 'Ссылка на пользователя';


--
-- Name: COLUMN notifications.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.notifications.type IS 'Тип уведомления: telegram или email';


--
-- Name: COLUMN notifications.template_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.notifications.template_name IS 'Название шаблона уведомления';


--
-- Name: COLUMN notifications.payload; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.notifications.payload IS 'Данные для шаблона в формате JSONB';


--
-- Name: COLUMN notifications.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.notifications.status IS 'Статус отправки уведомления';


--
-- Name: COLUMN notifications.sent_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.notifications.sent_at IS 'Когда уведомление было отправлено';


--
-- Name: COLUMN notifications.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.notifications.created_at IS 'Когда уведомление было создано';


--
-- Name: quiz_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz_attempts (
    id uuid NOT NULL,
    candidate_id uuid NOT NULL,
    quiz_id integer NOT NULL,
    answers jsonb NOT NULL,
    score double precision NOT NULL,
    completed_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.quiz_attempts OWNER TO postgres;

--
-- Name: COLUMN quiz_attempts.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_attempts.id IS 'Уникальный UUID попытки квиза';


--
-- Name: COLUMN quiz_attempts.candidate_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_attempts.candidate_id IS 'Ссылка на кандидата';


--
-- Name: COLUMN quiz_attempts.quiz_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_attempts.quiz_id IS 'Ссылка на квиз';


--
-- Name: COLUMN quiz_attempts.answers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_attempts.answers IS 'Ответы кандидата в формате JSONB: {question_id: answer}';


--
-- Name: COLUMN quiz_attempts.score; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_attempts.score IS 'Итоговый балл (0-100)';


--
-- Name: COLUMN quiz_attempts.completed_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_attempts.completed_at IS 'Когда квиз был завершен';


--
-- Name: quiz_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz_questions (
    id integer NOT NULL,
    quiz_id integer NOT NULL,
    question_text text NOT NULL,
    question_type public.question_type NOT NULL,
    options jsonb NOT NULL,
    correct_answer jsonb NOT NULL,
    difficulty integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.quiz_questions OWNER TO postgres;

--
-- Name: COLUMN quiz_questions.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_questions.id IS 'Уникальный ID вопроса';


--
-- Name: COLUMN quiz_questions.quiz_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_questions.quiz_id IS 'Ссылка на квиз';


--
-- Name: COLUMN quiz_questions.question_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_questions.question_text IS 'Текст вопроса';


--
-- Name: COLUMN quiz_questions.question_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_questions.question_type IS 'Тип вопроса: single_choice или multiple_choice';


--
-- Name: COLUMN quiz_questions.options; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_questions.options IS 'Варианты ответов в формате JSONB: {option_id: option_text}';


--
-- Name: COLUMN quiz_questions.correct_answer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_questions.correct_answer IS 'Правильный ответ в формате JSONB (option_id или массив option_ids)';


--
-- Name: COLUMN quiz_questions.difficulty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_questions.difficulty IS 'Сложность вопроса (1-5)';


--
-- Name: COLUMN quiz_questions.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_questions.created_at IS 'Когда вопрос был создан';


--
-- Name: COLUMN quiz_questions.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quiz_questions.updated_at IS 'Когда вопрос последний раз обновлялся';


--
-- Name: quiz_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quiz_questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quiz_questions_id_seq OWNER TO postgres;

--
-- Name: quiz_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quiz_questions_id_seq OWNED BY public.quiz_questions.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    track_id integer NOT NULL,
    is_active integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.quizzes OWNER TO postgres;

--
-- Name: COLUMN quizzes.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quizzes.id IS 'Уникальный ID квиза';


--
-- Name: COLUMN quizzes.track_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quizzes.track_id IS 'Ссылка на трек';


--
-- Name: COLUMN quizzes.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quizzes.is_active IS 'Квиз активен и используется для оценки';


--
-- Name: COLUMN quizzes.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quizzes.created_at IS 'Когда квиз был создан';


--
-- Name: COLUMN quizzes.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.quizzes.updated_at IS 'Когда квиз последний раз обновлялся';


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quizzes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quizzes_id_seq OWNER TO postgres;

--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: resumes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resumes (
    id uuid NOT NULL,
    candidate_id uuid NOT NULL,
    education jsonb NOT NULL,
    experience jsonb NOT NULL,
    skills jsonb NOT NULL,
    portfolio_links jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.resumes OWNER TO postgres;

--
-- Name: COLUMN resumes.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.id IS 'Уникальный UUID резюме';


--
-- Name: COLUMN resumes.candidate_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.candidate_id IS 'Ссылка на кандидата';


--
-- Name: COLUMN resumes.education; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.education IS 'Образование в формате JSONB: {degree, field, institution, year}';


--
-- Name: COLUMN resumes.experience; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.experience IS 'Опыт работы в формате JSONB: [{company, position, years, description}]';


--
-- Name: COLUMN resumes.skills; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.skills IS 'Навыки в формате JSONB массива строк';


--
-- Name: COLUMN resumes.portfolio_links; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.portfolio_links IS 'Ссылки на портфолио в формате JSONB массива строк';


--
-- Name: COLUMN resumes.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.created_at IS 'Когда резюме было создано';


--
-- Name: COLUMN resumes.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resumes.updated_at IS 'Когда резюме последний раз обновлялось';


--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    hiring_manager_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: COLUMN teams.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.teams.id IS 'Уникальный ID команды';


--
-- Name: COLUMN teams.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.teams.name IS 'Название команды';


--
-- Name: COLUMN teams.hiring_manager_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.teams.hiring_manager_id IS 'Ссылка на нанимающего менеджера (рекрутера)';


--
-- Name: COLUMN teams.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.teams.created_at IS 'Когда команда была создана';


--
-- Name: COLUMN teams.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.teams.updated_at IS 'Когда команда последний раз обновлялась';


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO postgres;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: tracks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tracks (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    is_active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tracks OWNER TO postgres;

--
-- Name: COLUMN tracks.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tracks.id IS 'Уникальный ID трека';


--
-- Name: COLUMN tracks.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tracks.name IS 'Название трека (например, ''Python Backend'', ''Frontend'')';


--
-- Name: COLUMN tracks.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tracks.description IS 'Описание трека';


--
-- Name: COLUMN tracks.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tracks.is_active IS 'Трек активен и доступен для подачи заявок';


--
-- Name: COLUMN tracks.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tracks.created_at IS 'Когда трек был создан';


--
-- Name: COLUMN tracks.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tracks.updated_at IS 'Когда трек последний раз обновлялся';


--
-- Name: tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tracks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tracks_id_seq OWNER TO postgres;

--
-- Name: tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tracks_id_seq OWNED BY public.tracks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email character varying(320) NOT NULL,
    password_hash character varying(128) NOT NULL,
    role public.user_role NOT NULL,
    telegram_id character varying(100),
    is_active boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: COLUMN users.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.id IS 'Уникальный UUID пользователя';


--
-- Name: COLUMN users.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.email IS 'Email пользователя, используется как логин';


--
-- Name: COLUMN users.password_hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.password_hash IS 'Bcrypt-хэш пароля';


--
-- Name: COLUMN users.role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.role IS 'Роль пользователя: candidate или recruiter';


--
-- Name: COLUMN users.telegram_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.telegram_id IS 'ID пользователя в Telegram для уведомлений';


--
-- Name: COLUMN users.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.is_active IS 'Аккаунт активен/заблокирован';


--
-- Name: COLUMN users.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.created_at IS 'Когда аккаунт был создан';


--
-- Name: COLUMN users.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.updated_at IS 'Когда аккаунт последний раз обновлялся';


--
-- Name: vacancies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vacancies (
    id integer NOT NULL,
    track_id integer NOT NULL,
    team_id integer NOT NULL,
    requirements jsonb NOT NULL,
    is_open boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.vacancies OWNER TO postgres;

--
-- Name: COLUMN vacancies.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancies.id IS 'Уникальный ID вакансии';


--
-- Name: COLUMN vacancies.track_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancies.track_id IS 'Ссылка на трек';


--
-- Name: COLUMN vacancies.team_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancies.team_id IS 'Ссылка на команду';


--
-- Name: COLUMN vacancies.requirements; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancies.requirements IS 'Требования к кандидатам в формате JSONB: {required_skills, nice_to_have_skills, min_experience_years}';


--
-- Name: COLUMN vacancies.is_open; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancies.is_open IS 'Вакансия открыта и доступна для заявок';


--
-- Name: COLUMN vacancies.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancies.created_at IS 'Когда вакансия была создана';


--
-- Name: COLUMN vacancies.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancies.updated_at IS 'Когда вакансия последний раз обновлялась';


--
-- Name: vacancies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vacancies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vacancies_id_seq OWNER TO postgres;

--
-- Name: vacancies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vacancies_id_seq OWNED BY public.vacancies.id;


--
-- Name: vacancy_applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vacancy_applications (
    id uuid NOT NULL,
    application_id uuid NOT NULL,
    vacancy_id integer NOT NULL,
    assessment_id uuid,
    recruiter_notes text,
    status public.vacancy_application_status NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.vacancy_applications OWNER TO postgres;

--
-- Name: COLUMN vacancy_applications.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_applications.id IS 'Уникальный UUID заявки на вакансию';


--
-- Name: COLUMN vacancy_applications.application_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_applications.application_id IS 'Ссылка на общую заявку';


--
-- Name: COLUMN vacancy_applications.vacancy_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_applications.vacancy_id IS 'Ссылка на вакансию';


--
-- Name: COLUMN vacancy_applications.assessment_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_applications.assessment_id IS 'Ссылка на AI-оценку (может быть null)';


--
-- Name: COLUMN vacancy_applications.recruiter_notes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_applications.recruiter_notes IS 'Заметки рекрутера';


--
-- Name: COLUMN vacancy_applications.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_applications.status IS 'Статус заявки на вакансию';


--
-- Name: COLUMN vacancy_applications.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_applications.created_at IS 'Когда заявка на вакансию была создана';


--
-- Name: COLUMN vacancy_applications.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_applications.updated_at IS 'Когда заявка на вакансию последний раз обновлялась';


--
-- Name: vacancy_assessments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vacancy_assessments (
    id uuid NOT NULL,
    resume_id uuid NOT NULL,
    vacancy_id integer NOT NULL,
    overall_score double precision NOT NULL,
    breakdown jsonb NOT NULL,
    reasoning text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.vacancy_assessments OWNER TO postgres;

--
-- Name: COLUMN vacancy_assessments.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_assessments.id IS 'Уникальный UUID оценки';


--
-- Name: COLUMN vacancy_assessments.resume_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_assessments.resume_id IS 'Ссылка на резюме';


--
-- Name: COLUMN vacancy_assessments.vacancy_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_assessments.vacancy_id IS 'Ссылка на вакансию';


--
-- Name: COLUMN vacancy_assessments.overall_score; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_assessments.overall_score IS 'Общий балл оценки (0-100)';


--
-- Name: COLUMN vacancy_assessments.breakdown; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_assessments.breakdown IS 'Детализация оценки в формате JSONB: {skills_match, experience_match, education_match}';


--
-- Name: COLUMN vacancy_assessments.reasoning; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_assessments.reasoning IS 'Обоснование оценки от AI';


--
-- Name: COLUMN vacancy_assessments.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.vacancy_assessments.created_at IS 'Когда оценка была создана';


--
-- Name: quiz_questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions ALTER COLUMN id SET DEFAULT nextval('public.quiz_questions_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: tracks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracks ALTER COLUMN id SET DEFAULT nextval('public.tracks_id_seq'::regclass);


--
-- Name: vacancies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancies ALTER COLUMN id SET DEFAULT nextval('public.vacancies_id_seq'::regclass);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- Name: candidates candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidates
    ADD CONSTRAINT candidates_pkey PRIMARY KEY (id);


--
-- Name: interviews interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interviews
    ADD CONSTRAINT interviews_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: quiz_attempts quiz_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT quiz_attempts_pkey PRIMARY KEY (id);


--
-- Name: quiz_questions quiz_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_pkey PRIMARY KEY (id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: resumes resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: tracks tracks_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_name_key UNIQUE (name);


--
-- Name: tracks tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vacancies vacancies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancies
    ADD CONSTRAINT vacancies_pkey PRIMARY KEY (id);


--
-- Name: vacancy_applications vacancy_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_applications
    ADD CONSTRAINT vacancy_applications_pkey PRIMARY KEY (id);


--
-- Name: vacancy_assessments vacancy_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_assessments
    ADD CONSTRAINT vacancy_assessments_pkey PRIMARY KEY (id);


--
-- Name: ix_applications_candidate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_applications_candidate_id ON public.applications USING btree (candidate_id);


--
-- Name: ix_applications_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_applications_id ON public.applications USING btree (id);


--
-- Name: ix_applications_quiz_attempt_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_applications_quiz_attempt_id ON public.applications USING btree (quiz_attempt_id);


--
-- Name: ix_applications_resume_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_applications_resume_id ON public.applications USING btree (resume_id);


--
-- Name: ix_candidates_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_candidates_id ON public.candidates USING btree (id);


--
-- Name: ix_candidates_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_candidates_user_id ON public.candidates USING btree (user_id);


--
-- Name: ix_interviews_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_interviews_id ON public.interviews USING btree (id);


--
-- Name: ix_interviews_vacancy_application_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_interviews_vacancy_application_id ON public.interviews USING btree (vacancy_application_id);


--
-- Name: ix_notifications_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_notifications_id ON public.notifications USING btree (id);


--
-- Name: ix_notifications_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_notifications_user_id ON public.notifications USING btree (user_id);


--
-- Name: ix_quiz_attempts_candidate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_quiz_attempts_candidate_id ON public.quiz_attempts USING btree (candidate_id);


--
-- Name: ix_quiz_attempts_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_quiz_attempts_id ON public.quiz_attempts USING btree (id);


--
-- Name: ix_quiz_attempts_quiz_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_quiz_attempts_quiz_id ON public.quiz_attempts USING btree (quiz_id);


--
-- Name: ix_quiz_questions_quiz_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_quiz_questions_quiz_id ON public.quiz_questions USING btree (quiz_id);


--
-- Name: ix_quizzes_track_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_quizzes_track_id ON public.quizzes USING btree (track_id);


--
-- Name: ix_resumes_candidate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_resumes_candidate_id ON public.resumes USING btree (candidate_id);


--
-- Name: ix_resumes_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_resumes_id ON public.resumes USING btree (id);


--
-- Name: ix_teams_hiring_manager_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_teams_hiring_manager_id ON public.teams USING btree (hiring_manager_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_users_telegram_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_telegram_id ON public.users USING btree (telegram_id);


--
-- Name: ix_vacancies_team_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vacancies_team_id ON public.vacancies USING btree (team_id);


--
-- Name: ix_vacancies_track_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vacancies_track_id ON public.vacancies USING btree (track_id);


--
-- Name: ix_vacancy_applications_application_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vacancy_applications_application_id ON public.vacancy_applications USING btree (application_id);


--
-- Name: ix_vacancy_applications_assessment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vacancy_applications_assessment_id ON public.vacancy_applications USING btree (assessment_id);


--
-- Name: ix_vacancy_applications_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_vacancy_applications_id ON public.vacancy_applications USING btree (id);


--
-- Name: ix_vacancy_applications_vacancy_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vacancy_applications_vacancy_id ON public.vacancy_applications USING btree (vacancy_id);


--
-- Name: ix_vacancy_assessments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_vacancy_assessments_id ON public.vacancy_assessments USING btree (id);


--
-- Name: ix_vacancy_assessments_resume_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vacancy_assessments_resume_id ON public.vacancy_assessments USING btree (resume_id);


--
-- Name: ix_vacancy_assessments_vacancy_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_vacancy_assessments_vacancy_id ON public.vacancy_assessments USING btree (vacancy_id);


--
-- Name: applications applications_candidate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_candidate_id_fkey FOREIGN KEY (candidate_id) REFERENCES public.candidates(id) ON DELETE CASCADE;


--
-- Name: applications applications_quiz_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_quiz_attempt_id_fkey FOREIGN KEY (quiz_attempt_id) REFERENCES public.quiz_attempts(id) ON DELETE CASCADE;


--
-- Name: applications applications_resume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_resume_id_fkey FOREIGN KEY (resume_id) REFERENCES public.resumes(id) ON DELETE CASCADE;


--
-- Name: candidates candidates_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidates
    ADD CONSTRAINT candidates_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: interviews interviews_vacancy_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interviews
    ADD CONSTRAINT interviews_vacancy_application_id_fkey FOREIGN KEY (vacancy_application_id) REFERENCES public.vacancy_applications(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quiz_attempts quiz_attempts_candidate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT quiz_attempts_candidate_id_fkey FOREIGN KEY (candidate_id) REFERENCES public.candidates(id) ON DELETE CASCADE;


--
-- Name: quiz_attempts quiz_attempts_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT quiz_attempts_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: quiz_questions quiz_questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: quizzes quizzes_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.tracks(id) ON DELETE CASCADE;


--
-- Name: resumes resumes_candidate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_candidate_id_fkey FOREIGN KEY (candidate_id) REFERENCES public.candidates(id) ON DELETE CASCADE;


--
-- Name: teams teams_hiring_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_hiring_manager_id_fkey FOREIGN KEY (hiring_manager_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: vacancies vacancies_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancies
    ADD CONSTRAINT vacancies_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: vacancies vacancies_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancies
    ADD CONSTRAINT vacancies_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.tracks(id) ON DELETE CASCADE;


--
-- Name: vacancy_applications vacancy_applications_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_applications
    ADD CONSTRAINT vacancy_applications_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.applications(id) ON DELETE CASCADE;


--
-- Name: vacancy_applications vacancy_applications_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_applications
    ADD CONSTRAINT vacancy_applications_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.vacancy_assessments(id) ON DELETE SET NULL;


--
-- Name: vacancy_applications vacancy_applications_vacancy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_applications
    ADD CONSTRAINT vacancy_applications_vacancy_id_fkey FOREIGN KEY (vacancy_id) REFERENCES public.vacancies(id) ON DELETE CASCADE;


--
-- Name: vacancy_assessments vacancy_assessments_resume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_assessments
    ADD CONSTRAINT vacancy_assessments_resume_id_fkey FOREIGN KEY (resume_id) REFERENCES public.resumes(id) ON DELETE CASCADE;


--
-- Name: vacancy_assessments vacancy_assessments_vacancy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vacancy_assessments
    ADD CONSTRAINT vacancy_assessments_vacancy_id_fkey FOREIGN KEY (vacancy_id) REFERENCES public.vacancies(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict WHnWaDEHZXpFHAqBTv6h5FyxL4hE98LuhsbrgTYjdNnBYPcepvd3hOQx5FqqX9d

