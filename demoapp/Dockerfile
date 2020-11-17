FROM golang:alpine AS build-env

# Set necessary environmet variables needed for our image

# Move to working dir
RUN mkdir /go/src/app && apk update && apk add git
ADD demoapp.go /go/src/app/

WORKDIR /go/src/app

# Copy the code into the container
# COPY ./demoapp.go .

# Build the application
# RUN go build -o demoapp ./demoapp.go
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o app .

# Move to /dist directory as the place for resulting binary folder
# WORKDIR /dist

# Copy binary from build to main folder
# RUN cp /build/demoapp .

# EXPOSE 80

# Build a small image
FROM scratch
WORKDIR /app
COPY --from=build-env /go/src/app/app .
ENTRYPOINT ["./app"]
