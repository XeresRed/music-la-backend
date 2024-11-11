FROM node:18-alpine
LABEL org.opencontainers.image.authors="JuanCastano"
WORKDIR /build
RUN npm install pm2 -g
COPY  ./build ./
COPY server.js ./
CMD [ "pm2", "start","server.js" ]
