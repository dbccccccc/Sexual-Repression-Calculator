# Build stage
FROM node:22-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM denoland/deno:alpine-2.1.7

WORKDIR /app/dist

# Copy built files from builder
COPY --from=builder /app/dist .

# Expose port
EXPOSE 8000

# Start the application
CMD ["deno", "run", "--allow-net", "--allow-read", "server.cjs"]
