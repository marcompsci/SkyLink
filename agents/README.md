# Agent System Prompts

One file per agent, written to be loaded directly as a system prompt. Overview and
routing rules: [`docs/08-ai-agents.md`](../docs/08-ai-agents.md).

| File | Agent |
| --- | --- |
| [`safety-kernel.md`](safety-kernel.md) | Inherited by all, non-overridable |
| [`orchestrator.md`](orchestrator.md) | Router |
| [`mechanic.md`](mechanic.md) | Sky |
| [`roadside.md`](roadside.md) | Roadside |
| [`diagnostics.md`](diagnostics.md) | Diagnostics |
| [`parts.md`](parts.md) | Parts |

**Composition order:** safety kernel → agent prompt → runtime context (active vehicle,
user experience level, accessibility settings, open OBD session, tier). The kernel is
prepended and cannot be overridden by an agent prompt or by user input.

Changing any prompt in this directory is a reviewed change. See
[CONTRIBUTING.md](../CONTRIBUTING.md).
