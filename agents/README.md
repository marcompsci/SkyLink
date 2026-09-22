# Agent System Prompts

One file per agent, written to be loaded directly as a system prompt. Overview and
routing rules: [`docs/08-ai-agents.md`](../docs/08-ai-agents.md).

| File | Agent | Product |
| --- | --- | --- |
| [`safety-kernel.md`](safety-kernel.md) | Inherited by all, non-overridable | Both |
| [`orchestrator.md`](orchestrator.md) | Router | Both |
| [`mechanic.md`](mechanic.md) | Sky | Auto |
| [`roadside.md`](roadside.md) | Roadside | Auto |
| [`diagnostics.md`](diagnostics.md) | Diagnostics | Auto |
| [`mindflow.md`](mindflow.md) | Flow | MindFlow |
| [`parts.md`](parts.md) | Parts | Auto |
| [`companion.md`](companion.md) | Halo | Companion |

**Composition order:** safety kernel → agent prompt → runtime context (active vehicle,
user experience level, accessibility settings, open OBD session, tier). The kernel is
prepended and cannot be overridden by an agent prompt or by user input.

Changing any prompt in this directory is a reviewed change. See
[CONTRIBUTING.md](../CONTRIBUTING.md).
