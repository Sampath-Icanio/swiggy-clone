# ============================================================
# Swiggy Clone — Dockerfile
# TEACHING POINT: Two-stage build
#   Stage 1 (builder): injects the festival theme into JS
#   Stage 2 (runtime): lean nginx image, serves static files
# ============================================================

# ---- Stage 1: Build ----
FROM alpine:3.18 AS builder

# ARG = build-time variable passed from CI/CD pipeline
# Default is "default" (no festival theme)
ARG ACTIVE_THEME=default

WORKDIR /build
COPY public/ .

# TEACHING POINT: This is where the magic happens.
# We replace the placeholder {{ACTIVE_THEME}} in theme.js
# with the actual theme name at build time.
# The pipeline controls which theme gets baked in.
RUN sed -i "s/{{ACTIVE_THEME}}/${ACTIVE_THEME}/g" theme.js
# ---- Stage 2: Runtime ----
FROM nginx:alpine

# Copy our custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built static files from stage 1
COPY --from=builder /build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# nginx runs in foreground
CMD ["nginx", "-g", "daemon off;"]
