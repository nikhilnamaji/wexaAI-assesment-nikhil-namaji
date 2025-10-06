# Stage 1: Build the application
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY nextjs-app/package*.json ./
RUN npm install

# Copy the rest of the app and build
COPY nextjs-app/ .
RUN npm run build

# Stage 2: Production image
FROM node:18-alpine
WORKDIR /app

# Copy built app and package files
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Install only production dependencies
RUN npm install --omit=dev

# Expose port
EXPOSE 3000

# Start the app
CMD ["npx", "next", "start"]