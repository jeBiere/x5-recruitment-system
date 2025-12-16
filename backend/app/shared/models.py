"""Shared database models."""

import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, Enum, String, func
from sqlalchemy.dialects.postgresql import UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.shared.enums import UserRole


class User(Base):
    """User model representing system users (candidates and recruiters)."""

    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        index=True,
        comment="Уникальный UUID пользователя"
    )

    email: Mapped[str] = mapped_column(
        String(320),
        unique=True,
        nullable=False,
        index=True,
        comment="Email пользователя, используется как логин"
    )

    password_hash: Mapped[str] = mapped_column(
        String(128),
        nullable=False,
        comment="Bcrypt-хэш пароля"
    )

    role: Mapped[UserRole] = mapped_column(
        Enum(UserRole, name="user_role", create_type=True),
        nullable=False,
        comment="Роль пользователя: candidate или recruiter"
    )

    telegram_id: Mapped[str | None] = mapped_column(
        String(100),
        unique=True,
        nullable=True,
        index=True,
        comment="ID пользователя в Telegram для уведомлений"
    )

    is_active: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
        nullable=False,
        comment="Аккаунт активен/заблокирован"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда аккаунт был создан"
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
        comment="Когда аккаунт последний раз обновлялся"
    )

    # Relationships
    candidate: Mapped["Candidate"] = relationship(
        "Candidate",
        back_populates="user",
        cascade="all, delete-orphan",
        uselist=False,
    )

    notifications: Mapped[list["Notification"]] = relationship(
        "Notification",
        back_populates="user",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        """String representation of User.

        Returns:
            str: User representation.
        """
        return f"<User(id={self.id}, email={self.email}, role={self.role})>"
