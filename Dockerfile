FROM node:17.2.0-alpine3.13

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm ci --production

COPY src src

ENV PORT=5020
EXPOSE ${PORT}

CMD node ./src/bin/start.mjs