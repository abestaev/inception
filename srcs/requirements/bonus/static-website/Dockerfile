FROM debian:bookworm

# Install nginx
RUN apt-get update && \
    apt-get install -y nginx curl && \
    rm -rf /var/lib/apt/lists/*

# Copy static website files
COPY . /usr/share/nginx/html/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create a simple health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

# Expose port 8081
EXPOSE 8081

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
