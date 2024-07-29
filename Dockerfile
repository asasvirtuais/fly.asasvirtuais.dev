LABEL fly_launch_runtime='node'

ENV NODE_ENV='production'

FROM node:lts-slim as base

WORKDIR /app

COPY --link . .

RUN npm install --frozen-lockfile

FROM base as build

RUN npm run build

FROM base

COPY --from=build /app/dist /app/dist

EXPOSE 3000

CMD [ "npm", "start" ]