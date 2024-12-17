FROM node:20-alpine AS build
WORKDIR /build/
# Install packages
COPY package.json package-lock.json ./
RUN npm i
# Initialise prisma
COPY prisma/schema.prisma prisma/schema.prisma
RUN npx prisma generate
# Copy and compile source code
COPY . .
RUN npm run build

FROM node:20-alpine AS prod
WORKDIR /app/
RUN apk add --no-cache openssl
COPY --from=build /build/package.json /build/package-lock.json ./
COPY --from=build /build/ ./
EXPOSE 3000
ENV NODE_ENV=production
ENTRYPOINT ["sh", "-c", "npx prisma db push && npm run start:prod"]
