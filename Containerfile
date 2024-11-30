# Use an official Ubuntu as a parent image
FROM debian:stable-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y mtr-tiny curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the mtr-multiflexi executable to the container
COPY mtr-multiflexi /usr/local/bin/mtr-multiflexi

# Make sure the mtr-multiflexi executable has the correct permissions
RUN chmod +x /usr/local/bin/mtr-multiflexi

# Define the entrypoint
ENTRYPOINT ["mtr-multiflexi"]

# Define the default command
#CMD ["--help"]
