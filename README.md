# Open WebUI in GitHub Codespaces

Run [Open WebUI](https://github.com/open-webui/open-webui) in a GitHub Codespace — with support for external LLM APIs (OpenAI, Anthropic and others via Amplify Fusion or LiteLLM) and/or local Ollama models.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/lbrenman/open-webui-codespace)


## Quick Start

### External APIs only (lightweight, 2-core/8GB machine)

This is the setup for using Open WebUI with an Amplify Fusion OpenAI-compliant API or any external OpenAI-compliant API.

A sample Fusion API for use with Open WebUI can be found [here](https://github.com/lbrenman/fusion-openai-api-open-webui)

An OpenAI compliant OpenAPI specification, `OpenAI-compatible.yaml` is included in the repo. It is the external API spec that Open WebUI will call. Note that Open WebUI does not call the `/health` method. It calls:
* GET /v1/models — on startup and when refreshing connections
* POST /v1/chat/completions — when you send a message

Make sure CORS is configured for the external API, namely allow `Authorization` and `content-type` headers and allow `GET` and `POST` methods.

For Amplify Fusion, it is recommended to secure the API with OAuth 2.0 and retrieve a long lived access token to use as the OPENAI_API_KEY in the .env file

1. Open this repo in a GitHub Codespace
2. Copy and edit your env file (done automatically by COdeSpace startup script):
   ```bash
   cp .env.example .env
   # Edit .env and add your API keys
   ```
   > For Amplify Fusion, edit the External OpenAI section of .env and enter your base URL, OPENAI_API_BASE_URL (e.g. https://axway-appc-se-design.sandbox.fusion.services.axway.com:4443/OpenWebUIAPI/v1) and enter a long lived Fusion OAuth 2.0 Access token for the API Key, OPENAI_API_KEY. Alternatively, while not recommended, you can set the Fusion API security to `none` and set OPENAI_API_KEY to `dummy` but your Fusion API will be exposed to the public unsecured.
3. Start Open WebUI:
   ```bash
   ./scripts/start-external.sh
   ```
4. Open forwarded **port 3000**, create an admin account, and start chatting
   > Note CodeSpace will automatically open the Open WebUI app in a new tab and it may do so prematurely before Open WebUI is fully loaded so wait and click refresh

Open WebUI streams by default. You can turn it off per-conversation in the UI:

Click the ⚙️ icon in the chat input area → toggle Stream Response off

Or globally in Admin Panel → Settings → Interface → Stream Response.

If your current external (e.g. Fusion) API doesn't support streaming yet, the easiest fix is to just ignore the stream flag and always return a regular JSON response — Open WebUI will still work, it just won't show the typewriter effect.

You can change the Base URL and Key in the admin settings.

---

### With Ollama (local models, 4-core/16GB+ machine)

1. Open this repo in a GitHub Codespace (**4-core/16GB minimum**)
2. Copy and edit your env file:
   ```bash
   cp .env.example .env
   # Edit .env — API keys are optional in this mode
   ```
3. Start Open WebUI + Ollama:
   ```bash
   ./scripts/start-with-ollama.sh
   ```
4. Open forwarded **port 3000**

---

## Open WebUI's auto-tagging feature

Open WebUI automatically categorizes conversations for organization and search. It sends a second call to your API after each message to generate tags for the conversation. It makes other calls as well related to title autogeneration and follow up suggestions.

You can disable these in Admin Panel → Settings → Interface:

Turn off Title Auto-Generation
Turn off Chat Tags Generation
Turn off Follow Up Generation

## Connecting to Anthropic (Claude)

Open WebUI doesn't natively support Anthropic's API directly. Two options:

### Option A — LiteLLM Proxy (recommended)
Run a LiteLLM proxy that wraps Claude behind an OpenAI-compatible endpoint, then point Open WebUI at it:

```bash
# In .env:
OPENAI_API_BASE_URL=http://host.docker.internal:4000
OPENAI_API_KEY=your-litellm-master-key
```

### Option B — Open WebUI Anthropic Pipe
Install the community Anthropic pipe function from the Open WebUI admin panel:
- Go to **Admin → Functions → Discover**
- Search for "Anthropic" and install the pipe
- Add your `ANTHROPIC_API_KEY` in the function settings

---

## Connecting to OpenAI

Set `OPENAI_API_KEY` in `.env` — that's it. GPT-4o, o1, and other models will appear in the model selector automatically.

---

## Scripts

| Script | Description |
|--------|-------------|
| `./scripts/start-external.sh` | Start Open WebUI with external APIs, no Ollama |
| `./scripts/start-with-ollama.sh` | Start Open WebUI + Ollama with local models |
| `./scripts/pull-model.sh [model]` | Pull an additional Ollama model |

---

## Restarts

* Stop and remove
  * `docker stop open-webui`
  * `docker rm open-webui`

* Restart
  * `./scripts/start-external.sh`

---

## Recommended Ollama Models for Codespaces (CPU)

| Model | Size | Notes |
|-------|------|-------|
| `phi3:mini` | ~2.3GB | Default, fastest on CPU |
| `llama3.2:3b` | ~2GB | Good general purpose |
| `mistral:7b` | ~4.1GB | Needs 16GB+ RAM |
| `deepseek-r1:7b` | ~4.7GB | Strong reasoning |
| `qwen2.5:7b` | ~4.7GB | Strong coding |

---

## Ports

| Port | Service |
|------|---------|
| 3000 | Open WebUI |
| 11434 | Ollama API (when running) |

---

## Notes

- `.env` is gitignored — your API keys are never committed
- Open WebUI persists conversation history in a Docker volume (`open-webui`)
- After a Codespace resumes from sleep, re-run the appropriate start script
