# Use an official Flutter runtime as the base image
FROM google/dart:2.12

# Set the working directory in the container
WORKDIR /app

# Copy the Flutter app source code into the container
COPY . .

# Install Flutter SDK
RUN sudo apt-get install unzip
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH "$PATH:/app/flutter/bin"

RUN flutter pub get

# Build the Flutter app
RUN flutter build release

# Expose the port your app will run on (if needed)
EXPOSE 8080

# Start your Flutter app
CMD ["flutter", "run", "--release"]
