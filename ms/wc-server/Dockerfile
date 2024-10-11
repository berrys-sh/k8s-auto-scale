FROM node:18-alpine AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
# Our Second stage, that creates an image for production
FROM node:18-alpine AS prod
WORKDIR /app
COPY --from=builder ./app/dist ./dist
COPY package* ./
RUN npm install --production
CMD npm start
