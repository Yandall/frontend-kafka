# syntax=docker/dockerfile:1

FROM node:16.9.0

RUN npm install -g http-server

WORKDIR /FRONTEND-KAFKA

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

CMD [ "npm", "start" ]