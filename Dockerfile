# ---- STAGE 1: Build the Go app ----
FROM golang:1.22 AS builder

WORKDIR /app

# Copy go.mod and install dependencies
COPY go.mod .
RUN go mod download

# Copy and build
COPY . .

# Build a go application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main

# ---- STAGE 2: Create minimal final image ----
FROM gcr.io/distroless/static:nonroot

# Copy binary from builder
COPY --from=builder /app/main /

# Copied static content
COPY --from=builder /app/static /static

EXPOSE 8080

# Use non-root user (UID 65532)
USER nonroot:nonroot

# Command to run and not easy to override this
ENTRYPOINT ["/main"]
