export type UserRole = 'candidate' | 'recruiter';

export interface User {
  id: string;
  email: string;
  role: UserRole;
  telegram_id: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface RegisterRequest {
  email: string;
  password: string;
  role: UserRole;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface TokenResponse {
  access_token: string;
  token_type: string;
}

export interface RegisterResponse extends TokenResponse {
  user: User;
}
