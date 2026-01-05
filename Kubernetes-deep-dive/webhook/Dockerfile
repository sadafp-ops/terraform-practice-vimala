FROM python:3.11-slim

WORKDIR /app

# Install runtime deps
RUN pip install --no-cache-dir flask

# Copy app
COPY validate.py /app/validate.py

EXPOSE 8443

# Run the Flask app; it expects TLS cert/key to be mounted at /tls
CMD ["python", "validate.py"]