FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY templates/ templates/

ENV PGHOST=localhost
ENV PGPORT=5432
ENV PGDATABASE=cloudbuild
ENV PGUSER=cloudbuild
ENV PGPASSWORD=cloudbuild

EXPOSE 8080

CMD ["python", "app.py"]
