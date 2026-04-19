# SOP: SSH Session Startup for WP Engine

Run this procedure at the start of any session that involves SSH commands to WPE servers.
Skipping it costs 30+ seconds per SSH call due to agent re-initialization overhead.

---

## Why this matters

Desktop Commander (the tool Claude uses to run shell commands) creates a new isolated
process for each tool call. SSH agent state does not persist between processes.
Without this procedure, every single SSH command requires its own agent initialization,
adding ~30 seconds of overhead per call. On a session with 20+ SSH calls, that is
10+ minutes of pure waste.

The fix: start one persistent shell process, initialize the agent once, then reuse
that process PID for all subsequent SSH commands via `interact_with_process`.

---

## Step 1 — Start persistent shell and initialize SSH agent

Use `desktop-commander:start_process` with a long timeout:

```bash
eval "$(ssh-agent -s)" \
  && ssh-add /Users/jonathanhughes/.ssh/id_ed25519_itmanager \
  && echo "SSH agent ready"
```

Save the PID returned. All subsequent SSH commands go through this process.

Expected output:
```
Agent pid 12345
Identity added: /Users/jonathanhughes/.ssh/id_ed25519_itmanager (itmanager1341@gmail.com)
SSH agent ready
```

---

## Step 2 — Populate known_hosts for all WPE installs

Only needed once per machine, but run if any "Host key verification failed" errors appear:

```bash
ssh-keyscan -t rsa \
  thefivestar.ssh.wpengine.net \
  thefivestarstg.ssh.wpengine.net \
  thefivestardev.ssh.wpengine.net \
  mortgagepoint.ssh.wpengine.net \
  amaaonline.ssh.wpengine.net \
  >> /Users/jonathanhughes/.ssh/known_hosts 2>&1 \
  && echo "known_hosts updated"
```

---

## Step 3 — Verify connections

Test each environment you'll use in this session:

```bash
ssh thefivestar echo "production ok"
ssh thefivestarstg echo "staging ok"
```

Expected: `production ok` / `staging ok` with no errors.

If staging returns "not a WordPress installation" when running WP-CLI:
```bash
ssh thefivestarstg wp core download --skip-content
```
WPE staging environments are provisioned without WP core in the SSH container.
Downloading core fixes WP-CLI. This does not affect the live site — WPE mounts
core separately for HTTP requests.

---

## Step 4 — Confirm WP-CLI works on each target environment

```bash
ssh thefivestar wp plugin list --fields=name,status --format=table 2>&1 | head -5
ssh thefivestarstg wp plugin list --fields=name,status --format=table 2>&1 | head -5
```

If the PHP warning `Attempt to read property "hasMinimumVersion" on array` appears,
that is the known aioseo-redirects bug — suppressed by the mu-plugin on production
and staging. It is not a session blocker.

---

## Reusing the persistent process

After setup, use `desktop-commander:interact_with_process` with the saved PID:

```python
# Example: run a WP-CLI command in the persistent shell
interact_with_process(pid=12345, input='ssh thefivestar wp plugin list --format=table')
```

This avoids starting a new process for every command and eliminates agent
re-initialization overhead.

---

## WPE SSH limitations and workarounds

| Limitation | Workaround |
|-----------|-----------|
| SCP not supported | Use `cat file.php \| ssh install wp eval-file -` |
| Heredocs mangled over SSH | Write file locally, pipe via `wp eval-file -` |
| Python/inline scripts mangled | Same — write script to disk, pipe it in |
| WP core missing on new staging | `wp core download --skip-content` |
| Agent not persisting between tool calls | Use persistent process (this SOP) |
| `--path` flag ignored / incorrect | Check `~/.wp-cli/config.yml` on server |

---

## SSH config reference

Key file: `/Users/jonathanhughes/.ssh/id_ed25519_itmanager`
WPE portal fingerprint: `af:c0:8b:73:c0:b1:d7:39:cd:57:5f:5d:3c:76:3b:57`

Host aliases (from `~/.ssh/config`):
| Alias | Install | Environment |
|-------|---------|-------------|
| `thefivestar` | thefivestar | Production |
| `thefivestarstg` | thefivestarstg | Staging |
| `thefivestardev` | thefivestardev | Dev |
| `mortgagepoint` | mortgagepoint | Production |
| `amaaonline` | amaaonline | Production |

GitHub Actions deploy key: `wpengine_ed25519` (passphrase-free, registered in WPE
as "WPE GHA"). Used only by GitHub Actions via `WPE_SSHG_KEY_PRIVATE` secret.
Not used for interactive SSH.

---

## Checklist

Before starting SSH-heavy work:

- [ ] Persistent shell started, agent initialized
- [ ] known_hosts populated (no "Host key verification failed" errors)
- [ ] SSH connection verified on target environments
- [ ] WP-CLI verified (plugin list returns output, not "not a WordPress installation")
- [ ] Understood which environments will be touched (staging only? staging → prod?)
- [ ] Production approval gate understood: staging verified ✅ → stop → ask → wait
