"""
AWAS-AI AI Service
===================
FastAPI service for AI-powered appliance diagnostics,
image recognition, and predictive maintenance.
"""

from fastapi import FastAPI, HTTPException, UploadFile, File, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import logging
import structlog
from prometheus_client import make_asgi_app, Counter, Histogram

from app.config import settings
from app.routes import diagnostics, prediction, ocr
from app.core.ml_pipeline import MLPipeline
from app.core.vector_store import VectorStore

# Configure structured logging
structlog.configure(
    processors=[
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.StackInfoRenderer(),
        structlog.dev.set_exc_info,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer()
    ],
    wrapper_class=structlog.make_filtering_bound_logger(logging.INFO),
    context_class=dict,
    logger_factory=structlog.PrintLoggerFactory(),
    cache_logger_on_first_use=False
)

logger = structlog.get_logger()

# Prometheus metrics
REQUEST_COUNT = Counter(
    'ai_requests_total',
    'Total AI requests',
    ['endpoint', 'status']
)
REQUEST_LATENCY = Histogram(
    'ai_request_duration_seconds',
    'AI request latency',
    ['endpoint']
)

# Create FastAPI app
app = FastAPI(
    title="AWAS-AI Diagnostics Service",
    description="AI-powered appliance diagnostics and predictive maintenance",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize ML pipeline and vector store
ml_pipeline = MLPipeline()
vector_store = VectorStore()

@app.on_event("startup")
async def startup_event():
    """Initialize ML models and vector store on startup."""
    logger.info("Starting AI Service")
    await ml_pipeline.initialize()
    await vector_store.initialize()
    logger.info("AI Service ready")

@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup on shutdown."""
    logger.info("Shutting down AI Service")

# Health check
@app.get("/health", tags=["Health"])
async def health_check():
    return {
        "status": "healthy",
        "service": "ai-diagnostics",
        "version": "1.0.0"
    }

# Metrics endpoint for Prometheus
metrics_app = make_asgi_app()
app.mount("/metrics", metrics_app)

# Include routers
app.include_router(diagnostics.router, prefix="/api/v1/diagnostics", tags=["Diagnostics"])
app.include_router(prediction.router, prefix="/api/v1/prediction", tags=["Predictive Maintenance"])
app.include_router(ocr.router, prefix="/api/v1/ocr", tags=["OCR"])

# Root endpoint
@app.get("/", tags=["Root"])
async def root():
    return {
        "message": "AWAS-AI Diagnostics Service",
        "docs": "/docs",
        "metrics": "/metrics"
    }

# Global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    logger.error(
        "Unhandled exception",
        path=request.url.path,
        method=request.method,
        error=str(exc)
    )
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"}
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=5000,
        reload=settings.DEBUG,
        log_level="info"
    )