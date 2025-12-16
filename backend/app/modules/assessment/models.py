"""Assessment module database models."""

import uuid
from datetime import datetime

from sqlalchemy import DateTime, Enum, Float, ForeignKey, Integer, Text, func
from sqlalchemy.dialects.postgresql import JSONB, UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.shared.enums import QuestionType


class Quiz(Base):
    """Quiz model for track assessments."""

    __tablename__ = "quizzes"

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
        comment="Уникальный ID квиза"
    )

    track_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("tracks.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на трек"
    )

    is_active: Mapped[bool] = mapped_column(
        Integer,
        default=True,
        nullable=False,
        comment="Квиз активен и используется для оценки"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда квиз был создан"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда квиз последний раз обновлялся"
    )

    # Relationships
    track: Mapped["Track"] = relationship(
        "Track",
        back_populates="quizzes",
    )

    questions: Mapped[list["QuizQuestion"]] = relationship(
        "QuizQuestion",
        back_populates="quiz",
        cascade="all, delete-orphan",
    )

    attempts: Mapped[list["QuizAttempt"]] = relationship(
        "QuizAttempt",
        back_populates="quiz",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        """String representation of Quiz.

        Returns:
            str: Quiz representation.
        """
        return f"<Quiz(id={self.id}, track_id={self.track_id})>"


class QuizQuestion(Base):
    """Quiz question model."""

    __tablename__ = "quiz_questions"

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
        comment="Уникальный ID вопроса"
    )

    quiz_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("quizzes.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на квиз"
    )

    question_text: Mapped[str] = mapped_column(
        Text,
        nullable=False,
        comment="Текст вопроса"
    )

    question_type: Mapped[QuestionType] = mapped_column(
        Enum(QuestionType, name="question_type", create_type=True),
        nullable=False,
        comment="Тип вопроса: single_choice или multiple_choice"
    )

    options: Mapped[dict] = mapped_column(
        JSONB,
        nullable=False,
        comment="Варианты ответов в формате JSONB: {option_id: option_text}"
    )

    correct_answer: Mapped[dict] = mapped_column(
        JSONB,
        nullable=False,
        comment="Правильный ответ в формате JSONB (option_id или массив option_ids)"
    )

    difficulty: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        comment="Сложность вопроса (1-5)"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда вопрос был создан"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда вопрос последний раз обновлялся"
    )

    # Relationships
    quiz: Mapped["Quiz"] = relationship(
        "Quiz",
        back_populates="questions",
    )

    def __repr__(self) -> str:
        """String representation of QuizQuestion.

        Returns:
            str: QuizQuestion representation.
        """
        return f"<QuizQuestion(id={self.id}, difficulty={self.difficulty})>"


class VacancyAssessment(Base):
    """AI-powered vacancy assessment model."""

    __tablename__ = "vacancy_assessments"

    id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        index=True,
        comment="Уникальный UUID оценки"
    )

    resume_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("resumes.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на резюме"
    )

    vacancy_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("vacancies.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на вакансию"
    )

    overall_score: Mapped[float] = mapped_column(
        Float,
        nullable=False,
        comment="Общий балл оценки (0-100)"
    )

    breakdown: Mapped[dict] = mapped_column(
        JSONB,
        nullable=False,
        comment="Детализация оценки в формате JSONB: {skills_match, experience_match, education_match}"
    )

    reasoning: Mapped[str] = mapped_column(
        Text,
        nullable=False,
        comment="Обоснование оценки от AI"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда оценка была создана"
    )

    # Relationships
    resume: Mapped["Resume"] = relationship(
        "Resume",
        back_populates="vacancy_assessments",
    )

    vacancy: Mapped["Vacancy"] = relationship(
        "Vacancy",
        back_populates="vacancy_assessments",
    )

    vacancy_applications: Mapped[list["VacancyApplication"]] = relationship(
        "VacancyApplication",
        back_populates="assessment",
    )

    def __repr__(self) -> str:
        """String representation of VacancyAssessment.

        Returns:
            str: VacancyAssessment representation.
        """
        return f"<VacancyAssessment(id={self.id}, score={self.overall_score})>"
