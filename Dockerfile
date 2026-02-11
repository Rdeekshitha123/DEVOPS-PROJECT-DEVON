FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./
RUN npm install

# Copy source code
COPY public ./public
COPY src ./src

# Build React app
RUN npm run build

# Install nginx in same image
RUN apk add --no-cache nginx

# Configure nginx
RUN mkdir -p /usr/share/nginx/html \
 && rm -rf /usr/share/nginx/html/* \
 && cp -r /app/build/* /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
