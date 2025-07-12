# Agent Engine Analysis for AgenticAI-ADLC

This section contains detailed analysis of various agent "engines" that can be used by the Orchestrator to power specialized agents. The goal is to understand their capabilities, integration points, and how they fit into the overall architecture.

## Key Analyses:

*   **[Gemini CLI Core Integration](./gemini_cli_core.md)**: A deep dive into using the `packages/core` module from the Gemini CLI project as a headless agent engine. This covers its programmatic API, context management, and tool-use framework.

*   **[Claude Integration & Capabilities](./claude_integration.md)**: Analysis of using Claude models as an agent engine, focusing on its advanced code generation features, structured data output (JSON), and non-interactive/scriptable operation modes.

*   **[Multi-LLM Abstraction Layer](./llm_abstraction.md)**: The proposed design for the layer within the Orchestrator that will allow for seamless use of different agent engines and LLM backends (Gemini, Claude, OpenAI, OpenSource models, etc.).
