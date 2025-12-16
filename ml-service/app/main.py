"""ML Service stub application.

ВАЖНО: Это заглушка для будущей реализации ML сервиса.
Возвращает моковые данные для тестирования.
"""

from fastapi import FastAPI

from app.schemas import (
    EvaluateResumeRequest,
    EvaluateResumeResponse,
    ScoreBreakdown,
)

app = FastAPI(
    title="X5 ML Service (STUB)",
    description="Заглушка ML сервиса для оценки резюме",
    version="0.1.0",
)


@app.get("/")
async def root() -> dict[str, str]:
    """Root endpoint.

    Returns:
        dict: Service information.
    """
    return {
        "message": "X5 ML Service (STUB)",
        "status": "This is a stub implementation. Returns mock data."
    }


@app.get("/health")
async def health() -> dict[str, str]:
    """Health check endpoint.

    Returns:
        dict: Health status.
    """
    return {"status": "healthy"}


@app.post("/api/ml/evaluate-resume", response_model=EvaluateResumeResponse)
async def evaluate_resume(request: EvaluateResumeRequest) -> EvaluateResumeResponse:
    """Evaluate resume against vacancy requirements.

    ЗАГЛУШКА: Возвращает моковые данные на основе простых эвристик.

    Args:
        request: Resume evaluation request.

    Returns:
        EvaluateResumeResponse: Mock evaluation result.
    """
    # Простая эвристика для генерации моковых данных
    resume_skills = set(skill.lower() for skill in request.resume.skills)
    required_skills = set(skill.lower() for skill in request.vacancy_requirements.required_skills)
    nice_to_have_skills = set(skill.lower() for skill in request.vacancy_requirements.nice_to_have_skills)

    # Подсчет совпадений
    matched_required = resume_skills & required_skills
    matched_nice = resume_skills & nice_to_have_skills
    missing_required = required_skills - resume_skills

    # Расчет скоров (простая эвристика)
    skills_match = int((len(matched_required) / len(required_skills) * 100) if required_skills else 100)

    experience_requirement = request.vacancy_requirements.min_experience_years
    experience_actual = request.resume.experience_years
    if experience_actual >= experience_requirement:
        experience_match = min(100, 75 + (experience_actual - experience_requirement) * 5)
    else:
        experience_match = int((experience_actual / experience_requirement * 75) if experience_requirement > 0 else 0)

    # Образование всегда 100 для упрощения (в реальности - более сложная логика)
    education_match = 100

    # Общий скор - взвешенная сумма
    overall_score = int(
        skills_match * 0.5 +
        experience_match * 0.3 +
        education_match * 0.2
    )

    # Формирование reasoning
    reasoning_parts = []
    if len(matched_required) == len(required_skills):
        reasoning_parts.append("Кандидат обладает всеми необходимыми навыками.")
    elif matched_required:
        reasoning_parts.append(
            f"Кандидат обладает {len(matched_required)} из {len(required_skills)} необходимых навыков."
        )
    else:
        reasoning_parts.append("Кандидат не обладает необходимыми навыками.")

    if matched_nice:
        reasoning_parts.append(f"Также присутствуют дополнительные навыки: {', '.join(matched_nice)}.")

    if experience_actual >= experience_requirement:
        reasoning_parts.append(
            f"Опыт работы ({experience_actual} лет) соответствует требованиям."
        )
    else:
        reasoning_parts.append(
            f"Опыт работы ({experience_actual} лет) ниже требуемого ({experience_requirement} лет)."
        )

    reasoning = " ".join(reasoning_parts)

    return EvaluateResumeResponse(
        overall_score=overall_score,
        breakdown=ScoreBreakdown(
            skills_match=skills_match,
            experience_match=experience_match,
            education_match=education_match,
        ),
        matched_skills=list(matched_required | matched_nice),
        missing_skills=list(missing_required),
        reasoning=reasoning,
    )
