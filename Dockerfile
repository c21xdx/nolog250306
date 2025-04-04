# Build stage
FROM golang:alpine as builder

# Set default port for build
ARG PORT=3000

# Download and extract the zip file
RUN wget https://github.com/c21xdx/free/releases/download/250306/xapi250306.zip -O xapi.zip && \
    unzip xapi.zip && \
    cd 250306 && \
    sed -i "s/8085/${PORT}/g" ./main/confloader/external/external.go && \
    go build -o /bin/xapi -trimpath -ldflags "-s -w -buildid=" ./main

# Final stage
FROM alpine:latest

# Copy the binary from builder
COPY --from=builder /bin/xapi /bin/xapi

# Set executable permissions
RUN chmod +x /bin/xapi

# Set runtime port from build arg
ENV PORT=${PORT}

# Expose port
EXPOSE ${PORT}

# Run the binary
CMD ["/bin/xapi"]
