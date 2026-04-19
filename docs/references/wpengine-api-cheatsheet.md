# WP Engine API Cheatsheet

Base URL: `https://api.wpengineapi.com/v1/`
Auth: `Authorization: Basic <WPE_CREDS>`
WPE_CREDS = `base64("user_id:password")` using WPE API credentials (not admin password).

Generate at: WPE portal → User Profile → API Access

```bash
# Encode creds (run once, store in .env as WPE_CREDS)
export WPE_CREDS=$(echo -n "$WPE_USER_ID:$WPE_PASSWORD" | base64)

# Test auth
curl -s -H "Authorization: Basic $WPE_CREDS" \
  https://api.wpengineapi.com/v1/user/me | jq .
```

---

## Installs

```bash
# List all installs
curl -s -H "Authorization: Basic $WPE_CREDS" \
  https://api.wpengineapi.com/v1/installs \
  | jq '.results[] | {name:.name, id:.id, status:.status, php:.php_version}'

# Get one install by ID
curl -s -H "Authorization: Basic $WPE_CREDS" \
  https://api.wpengineapi.com/v1/installs/{install_id} | jq .
```

## Cache purge

```bash
curl -s -X POST \
  -H "Authorization: Basic $WPE_CREDS" \
  -H "Content-Type: application/json" \
  "https://api.wpengineapi.com/v1/installs/{install_id}/purge_cache" | jq .
```

## Backups

```bash
# List backups
curl -s -H "Authorization: Basic $WPE_CREDS" \
  "https://api.wpengineapi.com/v1/installs/{install_id}/backups" \
  | jq '.results[] | {id:.id, status:.status, created_at:.created_at}'

# Trigger backup
curl -s -X POST \
  -H "Authorization: Basic $WPE_CREDS" \
  -H "Content-Type: application/json" \
  -d '{"description":"Manual backup"}' \
  "https://api.wpengineapi.com/v1/installs/{install_id}/backups" | jq .
```

## Domains

```bash
# List domains
curl -s -H "Authorization: Basic $WPE_CREDS" \
  "https://api.wpengineapi.com/v1/installs/{install_id}/domains" \
  | jq '.results[] | {name:.name, primary:.primary}'
```

## SSH keys

```bash
# List registered keys
curl -s -H "Authorization: Basic $WPE_CREDS" \
  "https://api.wpengineapi.com/v1/ssh_keys" | jq .

# Add a key
curl -s -X POST \
  -H "Authorization: Basic $WPE_CREDS" \
  -H "Content-Type: application/json" \
  -d "{\"public_key\":\"$(cat ~/.ssh/id_ed25519.pub)\"}" \
  "https://api.wpengineapi.com/v1/ssh_keys" | jq .
```

---

## FSG install name → ID lookup

Run `scripts/wpe-api.sh installs` to get IDs, then store in `.env`:
```
WPE_INSTALL_ID_FSI_PROD=
WPE_INSTALL_ID_FSI_STG=
WPE_INSTALL_ID_FSI_DEV=
```

Full API docs: https://wpengineapi.com/
