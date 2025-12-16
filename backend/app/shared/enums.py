"""Shared enums for the recruitment system."""

from enum import Enum


class UserRole(str, Enum):
    """User role enumeration."""

    CANDIDATE = "candidate"
    RECRUITER = "recruiter"
    HIRING_MANAGER = "hiring_manager"


class ApplicationStatus(str, Enum):
    """Application status enumeration."""

    SUBMITTED = "submitted"
    SCREENING = "screening"
    INTERVIEWING = "interviewing"
    REJECTED = "rejected"
    HIRED = "hired"


class VacancyApplicationStatus(str, Enum):
    """Vacancy application status enumeration."""

    PENDING = "pending"
    SENT_TO_HM = "sent_to_hm"
    HM_APPROVED = "hm_approved"
    HM_REJECTED = "hm_rejected"
    INTERVIEW_SCHEDULED = "interview_scheduled"
    INTERVIEWED = "interviewed"
    OFFER = "offer"
    REJECTED = "rejected"


class InterviewStatus(str, Enum):
    """Interview status enumeration."""

    PENDING = "pending"
    CONFIRMED = "confirmed"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class QuestionType(str, Enum):
    """Quiz question type enumeration."""

    SINGLE_CHOICE = "single_choice"
    MULTIPLE_CHOICE = "multiple_choice"


class NotificationType(str, Enum):
    """Notification type enumeration."""

    TELEGRAM = "telegram"
    EMAIL = "email"


class NotificationStatus(str, Enum):
    """Notification status enumeration."""

    PENDING = "pending"
    SENT = "sent"
    FAILED = "failed"
