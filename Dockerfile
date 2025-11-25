# Build Stage
FROM hexpm/elixir:1.14.5-erlang-26.0.2-alpine-3.18.2 AS build

# Install build dependencies
RUN apk add --no-cache build-base git

# Set working directory
WORKDIR /app

# Set build environment
ENV MIX_ENV=prod

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files first for better caching
COPY mix.exs ./

# Fetch and compile dependencies
RUN mix deps.get --only $MIX_ENV && \
    mix deps.compile

# Copy config files
COPY config config

# Copy application source code
COPY lib lib

# Compile the application
RUN mix compile

# Create the release
RUN mix release

# Runtime Stage
FROM alpine:3.18.2 AS runtime

# Install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs

# Set working directory
WORKDIR /app

# Create non-root user for security
RUN addgroup -S phoenix && adduser -S phoenix -G phoenix

# Copy the release from build stage
COPY --from=build --chown=phoenix:phoenix /app/_build/prod/rel/phoenix_api ./

# Switch to non-root user
USER phoenix

# Expose the application port
EXPOSE 4000

# Set default environment variables
ENV PHX_HOST=localhost
ENV PHX_SERVER=true

# Start the application
CMD ["bin/phoenix_api", "start"]
