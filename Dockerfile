# Stage 1: Build the Node.js application
FROM amazonlinux:2023 as builder

# Install Node.js and npm
RUN yum update -y
RUN yum install -y nodejs npm

# Set the working directory
WORKDIR /var/lib/jenkins/workspace/Spyd-main

# Copy package.json and package-lock.json first for caching
COPY /var/lib/jenkins/workspace/Spyd-main/package*.json ./

# Install dependencies
RUN npm install

# Add the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Debugging step: List the contents of /app to ensure dist exists
RUN ls -alh /var/lib/jenkins/workspace/Spyd-main/dist

# Stage 2: Set up Nginx to serve the application
FROM nginx:latest

# Copy the built app files from the builder stage
COPY --from=builder /var/lib/jenkins/workspace/Spyd-main/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run Nginx to serve the app
CMD ["nginx", "-g", "daemon off;"]
