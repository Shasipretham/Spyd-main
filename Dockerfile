# Stage 1: Build the Node.js application
FROM node:16-alpine as builder

# Set the working directory
WORKDIR /Spyd-main

# Copy package.json and package-lock.json for caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Add the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Set up Nginx to serve the application
FROM nginx:latest

# Copy the built app files from the builder stage
COPY --from=builder /Spyd-main/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80
EXPOSE 5173

# Run Nginx to serve the app
CMD ["nginx", "-g", "daemon off;"]
