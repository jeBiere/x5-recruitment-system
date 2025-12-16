"""Candidates module database models."""

import uuid
from datetime import datetime

from sqlalchemy import DateTime, Float, ForeignKey, Integer, String, func
from sqlalchemy.dialects.postgresql import JSONB, UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class Candidate(Base):
    """Candidate profile model."""

    __tablename__ = "candidates"

    id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        index=True,
        comment="Уникальный UUID кандидата"
    )

    user_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        unique=True,
        nullable=False,
        index=True,
        comment="Ссылка на пользователя"
    )

    full_name: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
        comment="Полное имя кандидата"
    )

    phone: Mapped[str | None] = mapped_column(
        String(20),
        nullable=True,
        comment="Номер телефона"
    )

    location: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True,
        comment="Местоположение (город, страна)"
    )

    timezone: Mapped[str | None] = mapped_column(
        String(50),
        nullable=True,
        comment="Часовой пояс кандидата"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда профиль был создан"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда профиль последний раз обновлялся"
    )

    # Relationships
    user: Mapped["User"] = relationship(
        "User",
        back_populates="candidate",
    )

    resumes: Mapped[list["Resume"]] = relationship(
        "Resume",
        back_populates="candidate",
        cascade="all, delete-orphan",
    )

    quiz_attempts: Mapped[list["QuizAttempt"]] = relationship(
        "QuizAttempt",
        back_populates="candidate",
        cascade="all, delete-orphan",
    )

    applications: Mapped[list["Application"]] = relationship(
        "Application",
        back_populates="candidate",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        """String representation of Candidate.

        Returns:
            str: Candidate representation.
        """
        return f"<Candidate(id={self.id}, full_name={self.full_name})>"


class Resume(Base):
    """Resume model containing candidate's experience and skills."""

    __tablename__ = "resumes"

    id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        index=True,
        comment="Уникальный UUID резюме"
    )

    candidate_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("candidates.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на кандидата"
    )

    education: Mapped[dict] = mapped_column(
        JSONB,
        nullable=False,
        comment="Образование в формате JSONB: {degree, field, institution, year}"
    )

    experience: Mapped[dict] = mapped_column(
        JSONB,
        nullable=False,
        comment="Опыт работы в формате JSONB: [{company, position, years, description}]"
    )

    skills: Mapped[list] = mapped_column(
        JSONB,
        nullable=False,
        comment="Навыки в формате JSONB массива строк"
    )

    portfolio_links: Mapped[list] = mapped_column(
        JSONB,
        nullable=False,
        comment="Ссылки на портфолио в формате JSONB массива строк"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда резюме было создано"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда резюме последний раз обновлялось"
    )

    # Relationships
    candidate: Mapped["Candidate"] = relationship(
        "Candidate",
        back_populates="resumes",
    )

    vacancy_assessments: Mapped[list["VacancyAssessment"]] = relationship(
        "VacancyAssessment",
        back_populates="resume",
        cascade="all, delete-orphan",
    )

    applications: Mapped[list["Application"]] = relationship(
        "Application",
        back_populates="resume",
    )

    def __repr__(self) -> str:
        """String representation of Resume.

        Returns:
            str: Resume representation.
        """
        return f"<Resume(id={self.id}, candidate_id={self.candidate_id})>"


class QuizAttempt(Base):
    """Quiz attempt model storing candidate's quiz answers and score."""

    __tablename__ = "quiz_attempts"

    id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        index=True,
        comment="Уникальный UUID попытки квиза"
    )

    candidate_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("candidates.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на кандидата"
    )

    quiz_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("quizzes.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на квиз"
    )

    answers: Mapped[dict] = mapped_column(
        JSONB,
        nullable=False,
        comment="Ответы кандидата в формате JSONB: {question_id: answer}"
    )

    score: Mapped[float] = mapped_column(
        Float,
        nullable=False,
        comment="Итоговый балл (0-100)"
    )

    completed_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда квиз был завершен"
    )

    # Relationships
    candidate: Mapped["Candidate"] = relationship(
        "Candidate",
        back_populates="quiz_attempts",
    )

    quiz: Mapped["Quiz"] = relationship(
        "Quiz",
        back_populates="attempts",
    )

    applications: Mapped[list["Application"]] = relationship(
        "Application",
        back_populates="quiz_attempt",
    )

    def __repr__(self) -> str:
        """String representation of QuizAttempt.

        Returns:
            str: QuizAttempt representation.
        """
        return f"<QuizAttempt(id={self.id}, score={self.score})>"
