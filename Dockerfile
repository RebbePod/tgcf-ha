FROM python:3.10

ENV VENV_PATH="/venv"
ENV PATH="$VENV_PATH/bin:$PATH"
WORKDIR /app

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get upgrade -y && \
    apt-get install ffmpeg tesseract-ocr -y && \
    apt-get autoclean

# Install Poetry and create virtual environment
RUN pip install --upgrade poetry
RUN python -m venv /venv

# Copy application files
COPY . .

# Build and install application
RUN poetry build && \
    /venv/bin/pip install --upgrade pip wheel setuptools && \
    /venv/bin/pip install dist/*.whl

# Expose the web UI port
EXPOSE 8501

# Create necessary directories and set permissions
RUN mkdir -p /config/tgcf /data/tgcf && \
    chown -R nobody:nogroup /config/tgcf /data/tgcf

# Set environment variables for config and data paths
ENV CONFIG_PATH="/config/tgcf/config.yaml"
ENV DATA_PATH="/data/tgcf"

# Set the entry point
CMD tgcf-web --config "$CONFIG_PATH" --data "$DATA_PATH"
