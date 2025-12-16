"""Request and response schemas for ML service."""

from pydantic import BaseModel


class Education(BaseModel):
    """Education information."""

    degree: str
    field: str


class ResumeData(BaseModel):
    """Resume data for evaluation."""

    skills: list[str]
    experience_years: int
    education: Education
    projects: list[dict] = []


class VacancyRequirements(BaseModel):
    """Vacancy requirements."""

    required_skills: list[str]
    nice_to_have_skills: list[str] = []
    min_experience_years: int = 0


class EvaluateResumeRequest(BaseModel):
    """Request to evaluate resume."""

    resume: ResumeData
    vacancy_requirements: VacancyRequirements


class ScoreBreakdown(BaseModel):
    """Score breakdown by category."""

    skills_match: int
    experience_match: int
    education_match: int


class EvaluateResumeResponse(BaseModel):
    """Response with resume evaluation."""

    overall_score: int
    breakdown: ScoreBreakdown
    matched_skills: list[str]
    missing_skills: list[str]
    reasoning: str
