# ---- STAGE 1: Build the Go app ----
FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

# Build a statically linked binary for Linux
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .

# ---- STAGE 2: Minimal final image ----
FROM gcr.io/distroless/static:nonroot

# Copy binary explicitly to root /
COPY --from=builder /app/main /main

# Copy static folder if any
COPY --from=builder /app/static /static

EXPOSE 8080

USER nonroot:nonroot

CMD ["/main"]
