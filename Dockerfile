FROM node:20-alpine

WORKDIR /app
ADD luna-suave-source.tar /app/
RUN npm install --omit=dev
EXPOSE 3000
CMD ["node", "src/server.js"]
