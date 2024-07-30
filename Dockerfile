FROM node:lts-slim as base

WORKDIR /app

COPY --link . .

RUN npm install --frozen-lockfile

FROM base as build

RUN npm run build

FROM base

COPY --from=build /app/dist /app/dist

EXPOSE 3000

CMD [ "sh", "-c", "if [ \"$DOCKER_ENV\" = 'dev' ]; then npm run dev; else npm start; fi" ]