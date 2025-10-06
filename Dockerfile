# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json & package-lock.json from nextjs-app folder
COPY nextjs-app/package*.json ./

# Install dependencies (omit dev in production image)
RUN npm install --omit=dev

# Copy the rest of the app
COPY nextjs-app/. .

# Build the Next.js app
RUN npx next build

# Stage 2: Production
FROM node:18-alpine AS runner
WORKDIR /app

# Copy build from builder
COPY --from=builder /app /app

# Expose port
EXPOSE 3000

# Start app
CMD ["npx", "next", "start"]