FROM docker.io/nginx:1.27.0-alpine3.19-slim

# Remove default Nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom configuration
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
