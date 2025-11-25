# Phoenix API with API Key Authentication

A Phoenix-based REST API with API key authentication.

## Features

- **API Key Authentication**: Secure your API endpoints with API key authentication
- **Multiple Auth Methods**: Support for both `x-api-key` header and `Authorization: Bearer <key>` header
- **Public and Protected Endpoints**: Mix of authenticated and unauthenticated routes
- **JSON API**: RESTful JSON API structure

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd phoenix-test
   ```

2. Install dependencies:
   ```bash
   mix deps.get
   ```

3. Start the server:
   ```bash
   mix phx.server
   ```

The API will be available at `http://localhost:4000`.

## Configuration

### API Keys

**Development** (`config/dev.exs`):
```elixir
config :phoenix_api, :api_keys, [
  "dev-api-key-12345",
  "test-api-key-67890"
]
```

**Production**:
Set the `API_KEYS` environment variable with comma-separated values:
```bash
export API_KEYS="your-production-key-1,your-production-key-2"
```

Also set the required `SECRET_KEY_BASE`:
```bash
export SECRET_KEY_BASE=$(mix phx.gen.secret)
```

## API Endpoints

### Public Endpoints (No authentication required)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check endpoint |

### Protected Endpoints (API key required)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/protected` | Returns authentication status |
| GET | `/api/protected/data` | Returns sample data |

## Authentication

Provide your API key in one of two ways:

### Option 1: `x-api-key` Header
```bash
curl -H "x-api-key: dev-api-key-12345" http://localhost:4000/api/protected
```

### Option 2: `Authorization` Header
```bash
curl -H "Authorization: Bearer dev-api-key-12345" http://localhost:4000/api/protected
```

## Example Requests

### Health Check (Public)
```bash
curl http://localhost:4000/api/health
```

Response:
```json
{
  "status": "ok",
  "message": "API is running"
}
```

### Protected Endpoint (Requires API Key)
```bash
curl -H "x-api-key: dev-api-key-12345" http://localhost:4000/api/protected
```

Response:
```json
{
  "status": "authenticated",
  "message": "You have successfully accessed a protected endpoint"
}
```

### Protected Data (Requires API Key)
```bash
curl -H "x-api-key: dev-api-key-12345" http://localhost:4000/api/protected/data
```

Response:
```json
{
  "data": [
    {"id": 1, "name": "Item 1", "description": "First item"},
    {"id": 2, "name": "Item 2", "description": "Second item"},
    {"id": 3, "name": "Item 3", "description": "Third item"}
  ],
  "metadata": {
    "total": 3,
    "api_key_used": "dev-***"
  }
}
```

### Unauthorized Request
```bash
curl http://localhost:4000/api/protected
```

Response (401 Unauthorized):
```json
{
  "error": "Missing API key"
}
```

## Running Tests

```bash
mix test
```

## Docker

### Quick Start with Docker Compose

1. Set the required environment variables:
   ```bash
   export SECRET_KEY_BASE=$(openssl rand -base64 48)
   export API_KEYS="your-api-key-1,your-api-key-2"
   ```

2. Build and run the container:
   ```bash
   docker compose up --build
   ```

3. The API will be available at `http://localhost:4000`.

### Environment Variables

When running with Docker, you must configure the following environment variables:

| Variable | Description | Required |
|----------|-------------|----------|
| `SECRET_KEY_BASE` | Secret key for signing/encryption (64+ chars) | Yes |
| `API_KEYS` | Comma-separated list of valid API keys | Yes |
| `PHX_HOST` | Hostname for URL generation | No (default: `localhost`) |
| `PORT` | Port to listen on | No (default: `4000`) |

### Production Deployment

For production, set proper values for sensitive environment variables:

```bash
# Generate a secure secret key
export SECRET_KEY_BASE=$(openssl rand -base64 48)

# Set your production API keys
export API_KEYS="your-secure-api-key-1,your-secure-api-key-2"

# Run the container
docker compose up -d
```

### Building the Image Manually

```bash
# Build the image
docker build -t phoenix_api .

# Run the container
docker run -p 4000:4000 \
  -e SECRET_KEY_BASE="your-64-character-secret-key-base-here-make-it-long-enough" \
  -e API_KEYS="your-api-key" \
  -e PHX_HOST="localhost" \
  -e PORT="4000" \
  phoenix_api
```

### Development with Docker

For development with live code reloading, use the dev profile:

```bash
docker compose --profile dev up phoenix_api_dev
```

Note: This mounts your local directory into the container for live code updates.

## Project Structure

```
lib/
├── phoenix_api/
│   └── application.ex          # Application entry point
└── phoenix_api_web/
    ├── controllers/
    │   ├── error_json.ex       # Error handling
    │   ├── health_controller.ex # Health check controller
    │   └── protected_controller.ex # Protected endpoints
    ├── plugs/
    │   └── api_key_auth.ex     # API key authentication plug
    ├── endpoint.ex             # HTTP endpoint configuration
    └── router.ex               # Route definitions

config/
├── config.exs                  # Base configuration
├── dev.exs                     # Development configuration
├── prod.exs                    # Production configuration
├── runtime.exs                 # Runtime configuration
└── test.exs                    # Test configuration

test/
├── phoenix_api_web/
│   ├── controllers/
│   │   ├── health_controller_test.exs
│   │   └── protected_controller_test.exs
│   └── plugs/
│       └── api_key_auth_test.exs
└── support/
    └── conn_case.ex            # Test case helpers
```

## License

MIT