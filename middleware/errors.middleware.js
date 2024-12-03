class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
    this.status = `${statusCode}`.startsWith("4") ? "error" : "error";
    this.isOperational = true;
    

    Error.captureStackTrace(this, this.constructor);
  }
}
const globalErrorHandler = (err, req, res, next) => {
  err.statusCode = err.statusCode || 500;
  err.status = err.status || "error";

  if (process.env.NODE_ENV === "development") {
    res.status(err.statusCode).json({
      status: err.status,
      error: err,
      message: err.message,
      stack: err.stack,
    });
  } else {
    // Para producción, enviar menos información
    res.status(err.statusCode).json({
      status: err.status,
      message: err.message,
    });
  }
};

const notFound = (req, res, next) => {
  const error = new AppError(`No se encontró la ruta: ${req.originalUrl}`, 404);
  next(error);
};

const methodNotAllowed = (allowedMethods) => {
  return (req, res, next) => {
    if (allowedMethods.includes(req.method)) {
      return next();
    }
    return res.status(405).json({
      status: 'error',
      code: 405,
      message: `Método ${req.method} no es válido para ${req.originalUrl}`,
      allowedMethods: allowedMethods,
    });
  };
};

const asyncHandler = (fn) => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

module.exports = {
  AppError,
  globalErrorHandler,
  notFound,
  asyncHandler,
  methodNotAllowed,
};
