LABEL fly_launch_runtime='node'

FROM node:lts-slim as base

    WORKDIR /app

    ENV NODE_ENV='production'

FROM base as install

    COPY --link . .

    RUN npm install --frozen-lockfile

FROM install as build

    RUN npm build

FROM build

    COPY --from=build /app/dist /app/dist

    EXPOSE 3000

    CMD [ "npm", "start" ]
