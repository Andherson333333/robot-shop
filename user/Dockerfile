# Etapa de construcción
FROM node:18 AS build-env
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install

# Etapa de producción
FROM node:lts-alpine3.20
ENV INSTANA_AUTO_PROFILE=true
ENV INSTANA_SERVICE_NAME=user
WORKDIR /usr/src/app
COPY --from=build-env /usr/src/app /usr/src/app
COPY server.js ./
EXPOSE 8080
CMD ["node", "server.js"]
