# fmsg triage agent

An inbox agent with its own address on [fmsg](https://fmsg.org), the open messaging protocol for people and programs.
It runs as `@alisabir_claudecode@fmsg.ai`, a sub-address owned by `@alisabir@fmsg.ai`.

Pattern, the same one as [Relay](https://contra.com/p/AOM3OlYX-relay-ai-support-inbox-saa-s-mvp-nextjs-claude): **read, triage, draft, human approves, send.**

1. Any message from a third party is read as a full thread and triaged by Claude: priority, intent, a one-line summary, and a drafted reply in the owner's voice. If the model call fails, a small rules engine produces a conservative result so the agent never goes silent.
2. The owner gets a **Triage:** card in their own inbox with all of that. The third party gets nothing yet.
3. The owner replies `send` in the card thread and the agent delivers the drafted reply to the original sender, as a proper reply to their message. `skip` drops it. Nothing ever goes to a third party without that approval.

The agent is stateless. Each pass derives its work from fmsg itself: unread flags say what is new, and the card text carries the original message id and the proposed reply, so a `send` can be honoured by any later pass on any machine.

## Files

- `agent_ci.js`: single-pass version, run on a schedule by GitHub Actions (`.github/workflows/agent.yml`, every 5 minutes).
- `agent.js`: long-running version for a laptop or server. Polls every 20 s with a WebSocket nudge for instant pickup. Same behaviour.
- `start-agent.cmd`: Windows launcher for the long-running version.

## Running it yourself

You need an fmsg address. Create a sub-address for the agent and an API key for it in fmsg Settings, AI apps.

```
FMSG_API_KEY=fmsgk_...   # the sub-address key
FMSG_AGENT=@you_agent@fmsg.ai
FMSG_OWNER=@you@fmsg.ai
node agent_ci.js
```

Triage uses the [Claude Code CLI](https://docs.claude.com/en/docs/claude-code) in print mode (`claude -p`). On a server set `CLAUDE_CODE_OAUTH_TOKEN` from `claude setup-token`.

## fmsg API used

`POST /fmsg/token`, `GET /fmsg`, `GET /fmsg/{id}/thread/messages`, `GET /fmsg/{id}/data`, `POST /fmsg` (draft) then `POST /fmsg/{id}/send`, `POST /fmsg/{id}/read`. See the [Web API](https://fmsg.ai/docs/web-api) and [FMSG-003](https://fmsg.org/standards/fmsg-003-webapi/).

Built 2026-10-18 by Ali Sabir.
