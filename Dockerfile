# ---- Build stage ----
FROM golang:1.22 AS builder

WORKDIR /app

# Copy go.mod and download dependencies
COPY go.mod ./
RUN go mod download

# Copy all source code
COPY . .

# Build statically linked binary for Linux (no CGO)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .

# ---- Final stage (distroless) ----
FROM gcr.io/distroless/static:nonroot

# Copy binary to root directory
COPY --from=builder /app/main /main

# If you have static files (HTML etc.), copy them too
COPY --from=builder /app/static /static

# Expose port your app listens on
EXPOSE 8080

# Use non-root user for security
USER nonroot:nonroot

# Run your app
ENTRYPOINT ["/main"]

