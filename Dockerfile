FROM nginx:alpine

ENV APP_VERSION=1.0.0
ENV APP_ENVIRONMENT=production

COPY docker-entrypoint.sh /docker-entrypoint.d/40-generate-index.sh
RUN chmod +x /docker-entrypoint.d/40-generate-index.sh

EXPOSE 80
