# SPARC Step 1: Specification for AgenticAI-ADLC

This document defines the detailed specifications for the **AgenticAI-ADLC** project.

## 1.1 Project Overview

*   **Project Name:** AgenticAI-ADLC (Agentic AI Application Development Lifecycle Controller)
*   **Project Goal:** To create a sophisticated orchestration platform that manages a team of specialized AI agents to automate and assist in the complete application development lifecycle. The platform will support multiple LLM backends (commercial and OpenSource), track costs, and facilitate effective human-AI collaboration.

### Reflection
*The goal is intentionally broad to encompass the full lifecycle, from conception to deployment. The "Agent of Agents" paradigm is central, positioning the Orchestrator as a coordinator rather than a monolithic application. This approach prioritizes flexibility and extensibility.*

## 1.2 Target Audience

The primary audience includes:
*   **Software Development Teams:** To accelerate development tasks, improve code quality, and automate testing/documentation.
*   **Project Managers / Product Owners:** To get automated status updates, manage development workflows, and translate high-level requirements into actionable tasks.
*   **DevOps Engineers:** To automate CI/CD pipeline tasks, infrastructure management, and monitoring.
*   **Business Analysts:** To assist in requirement gathering, analysis, and documentation.

## 1.3 Functional Requirements

### FR-ORC-1: Core Orchestration
- **FR-ORC-1.1 (Task Input):** The system shall accept high-level tasks from users or external systems via a Command Center UI and a REST API.
- **FR-ORC-1.2 (Task Decomposition):** The system shall use a dedicated "Planner Agent" to analyze high-level tasks and decompose them into a directed graph of dependent sub-tasks.
- **FR-ORC-1.3 (Workflow Management):** The system shall manage the execution of the sub-task graph, dispatching tasks to appropriate agents only when their dependencies are met.

### FR-AGT-1: Agent Management
- **FR-AGT-1.1 (Specialization):** The system shall support the definition of specialized agent roles (e.g., RequirementsAgent, ArchitectAgent, CodeGenAgent, ReviewAgent, TestingAgent, JiraUpdateAgent).
- **FR-AGT-1.2 (Configuration):** Each agent role definition shall include:
    - A specific system prompt.
    - An assigned set of tools (built-in, custom, or MCP-based).
    - A default or specified LLM type (e.g., Gemini-Pro, Claude-Opus, Local-Llama3).
- **FR-AGT-1.3 (Agent Pool):** The orchestrator shall manage a pool of active agent instances, assigning tasks to available agents based on their role.
- **FR-AGT-1.4 (Headless Operation):** The system must interface with agent "engines" (like a refactored Gemini CLI or the Claude Code SDK) programmatically in a headless/non-interactive mode.

#### Example Agent Prompt (`CodeGenAgent` System Prompt)
```
You are an expert software engineer specializing in writing clean, efficient, and production-ready code in [language]. Your task is to implement the feature or fix described in the prompt, adhering strictly to the provided file context and architectural guidelines.

**Mandates:**
1.  **Analyze Provided Context:** Before writing any code, thoroughly analyze all provided file contents, API specifications, and architectural diagrams.
2.  **Adhere to Conventions:** Your generated code MUST mimic the style, formatting, naming conventions, and architectural patterns of the surrounding project code.
3.  **Use Specified Tools:** You have access to file system tools (`read_file`, `write_file`, `edit_file`) and version control tools (`git_commit`, `git_create_branch`). Use them as needed.
4.  **Work in Scope:** Only modify files within the specified scope for your task.
5.  **Output:** When your implementation is complete, output the list of modified file paths and a summary of changes in the specified JSON format.
```

### FR-LLM-1: Multi-LLM Support
- **FR-LLM-1.1 (Abstraction Layer):** The system shall include an abstraction layer to interact with multiple LLM backends (e.g., Google Gemini, Anthropic Claude, OpenAI, OpenSource models via a compatible API). This will be achieved by creating a generic `ContentGenerator` interface.
- **FR-LLM-1.2 (Model Assignment):** Allow assigning specific LLM models to agent roles or individual tasks to leverage the best model for the job (e.g., powerful models for coding, cheaper models for summarization).

### FR-COL-1: Collaboration & Workspace Management
- **FR-COL-1.1 (Shared Memory):** The system shall provide a shared memory system (e.g., a vector database or a structured key-value store) that agents can query and contribute to. This allows for persistent, shared context across the team.
- **FR-COL-1.2 (Version Control Integration):** The system shall manage agent interactions with Git repositories.
    - It must be able to create feature branches and/or Git worktrees for tasks to ensure isolation.
    - It must coordinate agents working on the same repo to prevent conflicts, potentially using a logical file check-in/check-out system.
- **FR-COL-1.3 (Inter-Agent Communication):** The system shall provide a mechanism for agents to pass artifacts and messages to each other, mediated by the Orchestrator.
- **FR-COL-1.4 (Human-in-the-Loop):** The system must provide clear points in workflows for human review and approval (e.g., approving an architectural design before coding begins).

### FR-RES-1: Resource Management & Tracking
- **FR-RES-1.1 (Cost Tracking):** The system must track LLM usage (e.g., input/output tokens) for each task and agent, providing cost analysis capabilities.
- **FR-RES-1.2 (Time Tracking):** The system must log the execution time for each sub-task and the overall task.

### FR-TOOL-1: External Tool Integration
- **FR-TOOL-1.1 (MCP Support):** The system shall be able to configure and use MCP (Model-Context Protocol) servers as a primary way to provide agents with tools for external systems (ADO, Jira, Teams).

### Reflection
*The functional requirements are designed to be modular. The core is the Orchestrator (FR-ORC), which manages Agents (FR-AGT). These agents are powered by LLMs (FR-LLM) and collaborate (FR-COL) using Tools (FR-TOOL), while their activity is tracked (FR-RES). This separation should allow for parallel development and clear component boundaries. The biggest challenge will be designing the generic "Agent Interface Layer" to accommodate different agent engines and the "Version Control Coordination" module to prevent chaos.*

## 1.4 Non-Functional Requirements
- **NFR-EXT-1 (Extensibility):** The architecture must allow for the addition of new agent roles, LLM backends, and external tools with minimal changes to the core orchestrator logic.
- **NFR-SEC-1 (Security):** All API keys, credentials, and sensitive project data must be stored securely. Agent access to tools and file systems must be appropriately sandboxed or scoped.
- **NFR-PER-1 (Performance):** The orchestrator's overhead for task management should be minimal. UI must be responsive. (Specific latency targets TBD).
- **NFR-SCL-1 (Scalability):** The system should be designed to scale to support [TBD] concurrent agents and [TBD] tasks.
- **NFR-USA-1 (Usability):** The Command Center UI must be intuitive for project managers and developers, providing clear insights into the agents' activities without overwhelming the user.

### Reflection
*Initially, focusing on Extensibility and Security is paramount. Scalability can be addressed iteratively. The challenge with Usability will be finding the right balance between providing deep visibility and maintaining a clean, high-level overview.*

## 1.5 User Scenarios & User Flows
*(This section will be expanded with diagrams and detailed steps)*

### 1.5.1 Scenario: New Feature Implementation
1.  **Initiation:** A Project Manager submits a high-level feature request via the Command Center UI: "Implement a 'Forgot Password' workflow for our web application."
2.  **Planning:** The Orchestrator assigns this to the `PlannerAgent`, which breaks it down into sub-tasks:
    - `[T1]` Analyze existing auth code.
    - `[T2]` Design API endpoint for password reset token generation.
    - `[T3]` Design UI for email input and password reset form.
    - `[T4]` Implement backend logic (depends on T2).
    - `[T5]` Implement frontend components (depends on T3).
    - `[T6]` Write integration tests (depends on T4, T5).
    - `[T7]` Request human review of the implementation.
3.  **Execution & Collaboration:**
    - `ArchitectAgent` takes T1, T2, T3, querying shared memory for existing API patterns. It produces an API spec and UI wireframe description. This artifact is flagged for human review.
    - A human developer approves the design in the Command Center.
    - Orchestrator creates a `feature/forgot-password` git worktree.
    - `CodeGenAgent-Backend` takes T4, working within the worktree to implement the API.
    - `CodeGenAgent-Frontend` takes T5, also in the worktree, implementing UI components.
    - `TestingAgent` takes T6.
4.  **Completion:**
    - The `ReviewAgent` checks the code for style and potential bugs.
    - The final implementation is presented to the human developer for final approval and manual merge.
    - The Orchestrator presents a summary report with total LLM costs and time taken.

## 1.6 UI/UX Considerations
- **Command Center Dashboard:** A central view showing ongoing high-level tasks, which agents are active, and system-wide alerts.
- **Workflow Visualization:** A graph or board view for each task, showing the dependency graph of sub-tasks and their current status (queued, running, completed, error, awaiting review).
- **Agent Interaction View:** A "drill-down" view for each sub-task, showing the conversation log between the Orchestrator and the agent, including prompts, tool calls, and final artifacts.
- **Cost Management Panel:** A view to monitor token consumption and estimated costs by project, agent, and time frame.

## 1.7 File Structure Proposal (for Orchestrator Project)
```
agenticai-adlc/
|-- src/
|   |-- orchestrator/
|   |   |-- main.py             # Main application entry point
|   |   |-- task_manager.py     # Handles task decomposition and workflow
|   |   |-- dispatcher.py       # Assigns tasks to agents
|   |   |-- agent_pool.py       # Manages lifecycle of agent instances
|   |   |-- context_manager.py  # Manages shared memory and task context
|   |   |-- vcs_coordinator.py  # Manages Git interactions
|   |   |-- tool_proxy.py       # Proxies agent requests to external tools
|   |-- agents/
|   |   |-- interface.py        # Abstract base class for all agent engines
|   |   |-- gemini_engine.py # Adapter for a refactored, model-agnostic Gemini CLI
|   |   |-- claude_engine.py  # Adapter for Claude Code SDK
|   |-- llms/
|   |   |-- content_generator.py      # Abstract base class for LLM backends
|   |   |-- gemini_generator.py       # Wrapper for Google Gemini API
|   |   |-- claude_generator.py       # Wrapper for Anthropic Claude API
|   |-- api/                    # REST API for the Command Center UI
|   |-- config/                 # Configuration files for orchestrator and agent roles
|-- ui/                         # Frontend code for the Command Center
|-- docs/
|-- tests/
|-- .env.example
|-- docker-compose.yml
```

## 1.8 Assumptions
1.  Programmatic APIs for all target LLMs (Gemini, Claude, etc.) are available and stable.
2.  OpenSource LLMs can be hosted to expose an OpenAI-compatible API for easier integration.
3.  The Gemini CLI can be refactored to be model-agnostic.
4.  MCP is a viable standard for integrating with key enterprise tools.
5.  Human oversight is a required and integral part of the workflow, not an exception.
