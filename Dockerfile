# Use an official Node.js runtime as the base image
FROM node:16-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and yarn.lock files to install dependencies
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the application code to the container
COPY . .

# Build the React application
RUN yarn build

# Stage 2: Serve the built files using a lightweight server (nginx)
FROM nginx:alpine

# Copy the build output from the previous stage to the nginx public directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose the default Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]