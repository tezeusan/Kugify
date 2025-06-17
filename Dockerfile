# Use the official lightweight Python 3.12 image
FROM python:3.12-slim

# Set the working directory to /app
WORKDIR /app

# Copy project metadata
COPY pyproject.toml ./

# Upgrade pip and install the package along with development dependencies (including uv)
RUN pip install --upgrade pip \
    && pip install .[dev]

# Copy the application code into the container
COPY app/ ./app/

# Expose port 8000 for the application
EXPOSE 8000

# Default command to run the FastAPI application using Uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
