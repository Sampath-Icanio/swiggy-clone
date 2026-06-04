# ============================================================
# Swiggy Clone — Dockerfile
# TEACHING POINT: Two-stage build
#   Stage 1 (builder): injects the festival theme into JS
#   Stage 2 (runtime): lean nginx image, serves static files
# ============================================================

# ---- Stage 1: Build ----
FROM alpine:3.18 AS builder

ARG ACTIVE_THEME=default

WORKDIR /build
COPY public/ .

# TEACHING POINT: This is where the magic happens.
# We replace {{ACTIVE_THEME}} in theme.js with the actual value at build time.
# Using awk instead of sed to avoid delimiter conflict issues.
RUN awk -v t="${ACTIVE_THEME}" '{gsub(/\{\{ACTIVE_THEME\}\}/, t); print}' theme.js > theme.tmp && mv theme.tmp theme.js

# ---- Stage 2: Runtime ----
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
