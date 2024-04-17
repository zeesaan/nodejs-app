# ---------- Base -----------
FROM node:18-alpine AS base

WORKDIR /app

## Install only production dependencies
COPY package.json .
RUN npm install --production

# ---------- Builder ----------
FROM base AS builder

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# ---------- Release ----------
FROM node:18-alpine AS release

WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/package.json ./

# Expose the port your app runs on
EXPOSE 3000

# Run your application
CMD [ "npm", "run", "start" ]
