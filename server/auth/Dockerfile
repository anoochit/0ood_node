# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory in the container to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY ./package*.json .
COPY ./server.js .

# # Copy the rest of the application code to the container
# COPY . .

# Install the dependencies 
RUN npm install
RUN npm rebuild bcrypt --build-from-source

# Expose the port the application will run on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
