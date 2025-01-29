# Stage 1: Build the Node.js application
FROM amazonlinux:2023 as builder

# Install Node.js and npm
RUN yum update -y
RUN yum install -y nodejs npm

# Set the working directory
WORKDIR /Spyd-main

# Copy package.json and package-lock.json first for caching
COPY Spyd-main/package*.json ./

# Install dependencies
RUN npm install

# Add the rest of the application code
COPY Spyd-main .

# Build the application
RUN npm run build

# Debugging step: List the contents of /app to ensure dist exists
RUN ls -alh /Spyd-main/dist

# Stage 2: Set up Nginx to serve the application
FROM nginx:latest

# Copy the built app files from the builder stage
COPY --from=builder /Spyd-main/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run Nginx to serve the app
CMD ["nginx", "-g", "daemon off;"]
