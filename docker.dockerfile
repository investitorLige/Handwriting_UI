FROM cirrusci/flutter:stable
WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .
EXPOSE 8080
CMD ["bash"]  # start container shell for running flutter commands
