# ---------- Base ----------
FROM node:18-alpine AS base

WORKDIR /app
RUN rm -rf tmp

# ---------- Builder ----------
# Creates:
# - node_modules: production dependencies (no dev dependencies)
# - dist: A production build compiled with Babel
FROM base AS builder

COPY package.json .

RUN npm install --production

COPY . .

RUN npm run build

#Remove dev dependencies
#RUN npm prune --production 

# ---------- Release ----------
FROM base AS release

COPY --from=builder /app ./

# COPY --from=builder /app/node_modules ./node_modules
#COPY --from=builder /app/.next ./.next
#COPY --from=builder /app/public ./public
#COPY --from=builder /app/next.config.js ./
#COPY --from=builder /app/pages ./pages
#COPY --from=builder /app/package.json ./

CMD [ "npm", "run", "start" ]
