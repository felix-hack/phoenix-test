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