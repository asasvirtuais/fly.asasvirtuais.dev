FROM node:lts-slim as base

LABEL fly_launch_runtime='node'

WORKDIR /app

ENV NODE_ENV='production'

RUN npm install -g pnpm@$latest

FROM base as install

COPY --link . .

RUN pnpm install --frozen-lockfile

FROM install as build

RUN pnpm build

FROM build as release

COPY --from=build /app/dist /app/dist

EXPOSE 3000
CMD [ "node", "dist/main.js" ]
