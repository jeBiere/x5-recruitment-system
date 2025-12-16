"""Recruitment module database models."""

import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, Enum, ForeignKey, Integer, Text, func
from sqlalchemy.dialects.postgresql import JSONB, UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.shared.enums import ApplicationStatus, InterviewStatus, VacancyApplicationStatus


class Application(Base):
    """General application model submitted by candidates."""

    __tablename__ = "applications"

    id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        index=True,
        comment="Уникальный UUID заявки"
    )

    candidate_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("candidates.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на кандидата"
    )

    resume_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("resumes.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на резюме"
    )

    quiz_attempt_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("quiz_attempts.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на попытку квиза"
    )

    status: Mapped[ApplicationStatus] = mapped_column(
        Enum(ApplicationStatus, name="application_status", create_type=True),
        nullable=False,
        default=ApplicationStatus.SUBMITTED,
        comment="Общий статус заявки"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда заявка была создана"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда заявка последний раз обновлялась"
    )

    # Relationships
    candidate: Mapped["Candidate"] = relationship(
        "Candidate",
        back_populates="applications",
    )

    resume: Mapped["Resume"] = relationship(
        "Resume",
        back_populates="applications",
    )

    quiz_attempt: Mapped["QuizAttempt"] = relationship(
        "QuizAttempt",
        back_populates="applications",
    )

    vacancy_applications: Mapped[list["VacancyApplication"]] = relationship(
        "VacancyApplication",
        back_populates="application",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        """String representation of Application.

        Returns:
            str: Application representation.
        """
        return f"<Application(id={self.id}, status={self.status})>"


class VacancyApplication(Base):
    """Application for a specific vacancy."""

    __tablename__ = "vacancy_applications"

    id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        index=True,
        comment="Уникальный UUID заявки на вакансию"
    )

    application_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("applications.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на общую заявку"
    )

    vacancy_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("vacancies.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на вакансию"
    )

    assessment_id: Mapped[uuid.UUID | None] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("vacancy_assessments.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
        comment="Ссылка на AI-оценку (может быть null)"
    )

    recruiter_notes: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
        comment="Заметки рекрутера"
    )

    status: Mapped[VacancyApplicationStatus] = mapped_column(
        Enum(VacancyApplicationStatus, name="vacancy_application_status", create_type=True),
        nullable=False,
        default=VacancyApplicationStatus.PENDING,
        comment="Статус заявки на вакансию"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда заявка на вакансию была создана"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда заявка на вакансию последний раз обновлялась"
    )

    # Relationships
    application: Mapped["Application"] = relationship(
        "Application",
        back_populates="vacancy_applications",
    )

    vacancy: Mapped["Vacancy"] = relationship(
        "Vacancy",
        back_populates="vacancy_applications",
    )

    assessment: Mapped["VacancyAssessment | None"] = relationship(
        "VacancyAssessment",
        back_populates="vacancy_applications",
    )

    interviews: Mapped[list["Interview"]] = relationship(
        "Interview",
        back_populates="vacancy_application",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        """String representation of VacancyApplication.

        Returns:
            str: VacancyApplication representation.
        """
        return f"<VacancyApplication(id={self.id}, status={self.status})>"


class Interview(Base):
    """Interview model for scheduled interviews."""

    __tablename__ = "interviews"

    id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        index=True,
        comment="Уникальный UUID интервью"
    )

    vacancy_application_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("vacancy_applications.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на заявку на вакансию"
    )

    scheduled_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        comment="Запланированное время интервью"
    )

    candidate_confirmed: Mapped[bool] = mapped_column(
        Boolean,
        default=False,
        nullable=False,
        comment="Кандидат подтвердил интервью"
    )

    hm_confirmed: Mapped[bool] = mapped_column(
        Boolean,
        default=False,
        nullable=False,
        comment="Нанимающий менеджер подтвердил интервью"
    )

    hm_feedback: Mapped[dict | None] = mapped_column(
        JSONB,
        nullable=True,
        comment="Обратная связь от HM в формате JSONB: {rating, notes}"
    )

    status: Mapped[InterviewStatus] = mapped_column(
        Enum(InterviewStatus, name="interview_status", create_type=True),
        nullable=False,
        default=InterviewStatus.PENDING,
        comment="Статус интервью"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда интервью было создано"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда интервью последний раз обновлялось"
    )

    # Relationships
    vacancy_application: Mapped["VacancyApplication"] = relationship(
        "VacancyApplication",
        back_populates="interviews",
    )

    def __repr__(self) -> str:
        """String representation of Interview.

        Returns:
            str: Interview representation.
        """
        return f"<Interview(id={self.id}, status={self.status})>"
