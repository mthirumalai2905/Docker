# Use a base image with Node.js and npm pre-installed
FROM node:latest AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and yarn.lock to the container
COPY package.json yarn.lock ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the React application with Vite
RUN npx vite build

# Use a lightweight Node.js base image for serving the production build
FROM node:latest AS production

# Set the working directory inside the container
WORKDIR /app

# Copy the production build from the previous stage
COPY --from=build /app/dist ./dist

# Install serve globally to serve the production build
RUN npm install -g serve

# Expose port 5173 for serving the application
EXPOSE 5173

# Command to serve the production build
CMD ["serve", "-s", "dist", "-l", "5173"]
