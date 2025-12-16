"""Notifications module database models."""

import uuid
from datetime import datetime

from sqlalchemy import DateTime, Enum, ForeignKey, Integer, String, func
from sqlalchemy.dialects.postgresql import JSONB, UUID as PG_UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.shared.enums import NotificationStatus, NotificationType


class Notification(Base):
    """Notification model for storing user notifications."""

    __tablename__ = "notifications"

    id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        unique=True,
        index=True,
        comment="Уникальный UUID уведомления"
    )

    user_id: Mapped[uuid.UUID] = mapped_column(
        PG_UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
        comment="Ссылка на пользователя"
    )

    type: Mapped[NotificationType] = mapped_column(
        Enum(NotificationType, name="notification_type", create_type=True),
        nullable=False,
        comment="Тип уведомления: telegram или email"
    )

    template_name: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
        comment="Название шаблона уведомления"
    )

    payload: Mapped[dict] = mapped_column(
        JSONB,
        nullable=False,
        comment="Данные для шаблона в формате JSONB"
    )

    status: Mapped[NotificationStatus] = mapped_column(
        Enum(NotificationStatus, name="notification_status", create_type=True),
        nullable=False,
        default=NotificationStatus.PENDING,
        comment="Статус отправки уведомления"
    )

    sent_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
        comment="Когда уведомление было отправлено"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
        comment="Когда уведомление было создано"
    )

    # Relationships
    user: Mapped["User"] = relationship(
        "User",
        back_populates="notifications",
    )

    def __repr__(self) -> str:
        """String representation of Notification.

        Returns:
            str: Notification representation.
        """
        return f"<Notification(id={self.id}, type={self.type}, status={self.status})>"
