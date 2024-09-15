# Step 1: Build Angular Application
FROM node:18 as build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build --prod

# Step 2: Create NGINX container to serve the Angular application
FROM nginx:alpine

# Remove default NGINX configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom NGINX configuration file
COPY ./docker/nginx.conf /etc/nginx/conf.d/

# Copy Angular build output to NGINX html directory
COPY --from=build /app/dist/szymon-kuc-frontend/browser /usr/share/nginx/html

# Rename index.csr.html to index.html to ensure the correct file is served
RUN mv /usr/share/nginx/html/index.csr.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
