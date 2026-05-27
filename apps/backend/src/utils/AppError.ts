export abstract class AppError extends Error {
  abstract readonly statusCode: number;
  abstract readonly code: string;
  readonly isOperational = true;

  protected constructor(message: string) {
    super(message);
    Object.setPrototypeOf(this, new.target.prototype);
  }
}

export class ValidationAppError extends AppError {
  readonly statusCode = 400;
  readonly code = 'VALIDATION_ERROR';

  constructor(message: string) {
    super(message);
  }
}

export class UnauthorizedAppError extends AppError {
  readonly statusCode = 401;
  readonly code = 'UNAUTHORIZED';

  constructor(message: string) {
    super(message);
  }
}

export class ForbiddenAppError extends AppError {
  readonly statusCode = 403;
  readonly code = 'FORBIDDEN';

  constructor(message: string) {
    super(message);
  }
}

export class NotFoundAppError extends AppError {
  readonly statusCode = 404;
  readonly code = 'NOT_FOUND';

  constructor(message: string) {
    super(message);
  }
}

export class ConflictAppError extends AppError {
  readonly statusCode = 409;
  readonly code = 'CONFLICT';

  constructor(message: string) {
    super(message);
  }
}

export class OperationalAppError extends AppError {
  readonly statusCode: number;
  readonly code: string;

  constructor(message: string, statusCode = 500, code = 'OPERATIONAL_ERROR') {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
  }
}
