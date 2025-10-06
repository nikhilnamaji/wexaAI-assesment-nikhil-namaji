# Stage 1: Build the app
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files from subfolder
COPY nextjs-app/package.json nextjs-app/package-lock.json ./

# Install dependencies
RUN npm ci

# Copy rest of the app
COPY nextjs-app ./

# Build Next.js
RUN npm run build

# Stage 2: Production image
FROM node:20-alpine AS runner
WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Expose port
EXPOSE 3000

# Start Next.js
CMD ["npm", "start"]