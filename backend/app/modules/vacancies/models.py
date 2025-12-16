"""Vacancies module database models."""

import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, ForeignKey, Integer, String, Text, func
from sqlalchemy.dialects.postgresql import JSONB, UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class Track(Base):
    """Track (direction) model representing internship programs."""

    __tablename__ = "tracks"

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
        comment="Уникальный ID трека"
    )

    name: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        nullable=False,
        comment="Название трека (например, 'Python Backend', 'Frontend')"
    )

    description: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
        comment="Описание трека"
    )

    is_active: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
        nullable=False,
        comment="Трек активен и доступен для подачи заявок"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда трек был создан"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда трек последний раз обновлялся"
    )

    # Relationships
    vacancies: Mapped[list["Vacancy"]] = relationship(
        "Vacancy",
        back_populates="track",
        cascade="all, delete-orphan",
    )

    quizzes: Mapped[list["Quiz"]] = relationship(
        "Quiz",
        back_populates="track",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        """String representation of Track.

        Returns:
            str: Track representation.
        """
        return f"<Track(id={self.id}, name={self.name})>"


class Team(Base):
    """Team model representing hiring teams."""

    __tablename__ = "teams"

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
        comment="Уникальный ID команды"
    )

    name: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
        comment="Название команды"
    )

    hiring_manager_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на нанимающего менеджера (рекрутера)"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда команда была создана"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда команда последний раз обновлялась"
    )

    # Relationships
    vacancies: Mapped[list["Vacancy"]] = relationship(
        "Vacancy",
        back_populates="team",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        """String representation of Team.

        Returns:
            str: Team representation.
        """
        return f"<Team(id={self.id}, name={self.name})>"


class Vacancy(Base):
    """Vacancy model representing open positions."""

    __tablename__ = "vacancies"

    id: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
        comment="Уникальный ID вакансии"
    )

    track_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("tracks.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на трек"
    )

    team_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("teams.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на команду"
    )

    requirements: Mapped[dict] = mapped_column(
        JSONB,
        nullable=False,
        comment="Требования к кандидатам в формате JSONB: {required_skills, nice_to_have_skills, min_experience_years}"
    )

    is_open: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
        nullable=False,
        comment="Вакансия открыта и доступна для заявок"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда вакансия была создана"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда вакансия последний раз обновлялась"
    )

    # Relationships
    track: Mapped["Track"] = relationship(
        "Track",
        back_populates="vacancies",
    )

    team: Mapped["Team"] = relationship(
        "Team",
        back_populates="vacancies",
    )

    vacancy_applications: Mapped[list["VacancyApplication"]] = relationship(
        "VacancyApplication",
        back_populates="vacancy",
        cascade="all, delete-orphan",
    )

    vacancy_assessments: Mapped[list["VacancyAssessment"]] = relationship(
        "VacancyAssessment",
        back_populates="vacancy",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        """String representation of Vacancy.

        Returns:
            str: Vacancy representation.
        """
        return f"<Vacancy(id={self.id}, track_id={self.track_id}, team_id={self.team_id})>"
