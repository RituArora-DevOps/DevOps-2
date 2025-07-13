# Use official Node.js LTS image
FROM node:20

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first for layer caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the backend files
COPY . .

# Expose port (make sure your backend uses this port)
EXPOSE 5000

# Start the server
CMD ["node", "server.js"]
