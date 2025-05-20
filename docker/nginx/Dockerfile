FROM node:lts-alpine3.21 as build
WORKDIR /app/frontend
COPY ./frontend/package.json ./
COPY ./frontend/package-lock.json ./
RUN npm cache clean --force
#RUN npm ci --silent
RUN npm ci --verbose
#RUN npm ci --silent --legacy-peer-deps
COPY ./frontend/ ./
RUN npm run build --verbose

# The Second Stage
# Copy React static files and start nginx
FROM nginx:stable-alpine
COPY --from=build /app/frontend/build /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]