FROM registry.gviet.vn:5000/library/node:18-alpine as build-stage

WORKDIR /app
RUN corepack enable
RUN corepack prepare pnpm@8.6.2 --activate

COPY .npmrc pnpm-lock.yaml ./

RUN pnpm fetch

COPY . .

RUN pnpm install -r --offline

RUN pnpm generate

FROM registry.gviet.vn:5000/library/nginx:stable-alpine as production-stage

COPY --from=build-stage /app/.output/public /usr/share/nginx/html