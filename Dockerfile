FROM node:18-alpine
LABEL org.opencontainers.image.authors="JuanCastano"
WORKDIR /build
RUN npm install pm2 -g
COPY  ./build ./build
COPY  ./.strapi ./.strapi
COPY  ./.cache ./.cache
COPY  ./package*.json ./
COPY server.js ./
RUN npm install --legacy-peer-deps
EXPOSE 1337
CMD [ "npm", "start" ]
