# Use official Golang image
FROM golang:1.22

# Set working directory inside container
WORKDIR /app

# Copy Go source files
COPY . .

# Build the Go application
RUN go build -o main .

# Expose the port your app runs on
EXPOSE 8080

# Run the app
CMD ["./main"]
