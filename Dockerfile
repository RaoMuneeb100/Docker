
# Build Angular project
FROM node:latest AS ANGULAR_BUILD
WORKDIR /app
COPY fCR(Frontend)/package.json CR(Frontend)/package-lock.json ./
RUN npm install
COPY CR(Frontend)/ .
RUN npm run build

# Build Node.js backend
FROM node:latest AS NODE_BUILD
WORKDIR /CR(Backend)  
COPY CR(Backend)/package.json CR(Backend)/package-lock.json ./
RUN npm install
COPY CR(Backend)/ .
RUN npm run build

# Final image containing Angular, Node.js, and PostgreSQL
FROM node:latest
RUN apt-get update && apt-get install -y postgresql-client
COPY --from=NODE_BUILD /CR(Backend) /CR(Backend)
COPY --from=ANGULAR_BUILD /app/dist /CR(Frontend)/public
WORKDIR /backend
EXPOSE 3000
CMD ["npm", "start"]

# Production-ready image
 FROM nginx:latest
#  COPY --from=BUILD_IMAGE /CR(Backend)/build /usr/ share/nginx/html
 COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

LABEL “Author” = “Muneeb”
ENV DEBIAN_FRONTEND = noninteractive
EXPOSE 80


