FROM node:18-alpine
LABEL org.opencontainers.image.authors="JuanCastano"
WORKDIR /
RUN npm install pm2 -g
COPY ./package*.json ./
RUN npm install
COPY  . .
RUN npm run build
EXPOSE 1337
CMD [ "npm", "start" ]
