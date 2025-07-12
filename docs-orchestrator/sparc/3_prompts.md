# SPARC Step 3: Initial Development Prompts

This document provides initial, high-level prompts that can be used to kickstart the development of each module by an AI agent (or a human developer).

## Module 1: Core Orchestrator

**Prompt:**
"You are tasked with building the core task management and workflow engine for the AgenticAI-ADLC platform using Python.

1.  **Design the Data Models:** Define the SQLAlchemy (or similar ORM) models for `Task` and `SubTask`. A `Task` represents the high-level user request, and `SubTask` represents a node in the dependency graph. A `SubTask` should have relationships to its dependencies and dependents.
2.  **Implement the Task Manager:** Create a `TaskManager` class that can:
    *   Accept a high-level task description.
    *   (For now, mock the Planner Agent) Decompose it into a predefined graph of `SubTask` objects and save them to the database.
3.  **Implement the Dispatcher:** Create a `Dispatcher` class that:
    *   Periodically queries the database for `SubTask`s whose dependencies are all 'completed'.
    *   For each ready sub-task, (for now, mock the agent assignment) log a message indicating which agent role is required and that the task is being 'dispatched'.
    *   Update the sub-task's status to 'in_progress'.

Please generate the initial Python code for these components, including the data models and class structures. Include comments explaining the logic."

## Module 2: Agent Abstraction & Management

**Prompt:**
"You are tasked with creating the agent abstraction layer for the AgenticAI-ADLC platform in Python. The goal is to support multiple underlying agent engines.

1.  **Define the Abstract Base Class:** Create an abstract base class (ABC) called `AgentEngine` with an abstract method `execute_task(prompt: str, tools: list) -> str`.
2.  **Create a Mock Engine:** Implement a `MockAgentEngine` that inherits from `AgentEngine`. Its `execute_task` method should simply log the prompt and tools it received and return a predefined JSON string simulating a successful code modification.
3.  **Create the Agent Pool:** Implement an `AgentPool` class that can:
    *   Be initialized with a configuration dictionary mapping agent roles to engine types (e.g., `{'CodeGenAgent': 'MockAgentEngine'}`).
    *   'Acquire' an agent for a specific role, returning an instance of the correct engine.
    *   'Release' an agent, making it available for other tasks.

Please generate the Python code for these classes. The focus should be on the structural design rather than complex implementation logic."

## Module 3: LLM Abstraction Layer

**Prompt:**
"You are tasked with building the LLM abstraction layer for the AgenticAI-ADLC platform in Python to ensure model independence.

1.  **Define the `ContentGenerator` ABC:** Create an abstract base class (ABC) named `ContentGenerator` with the following abstract methods:
    *   `generate_content(prompt: str) -> str`
    *   `count_tokens(text: str) -> int`
2.  **Implement a `MockContentGenerator`:** Create a concrete class `MockContentGenerator` that implements the `ContentGenerator` ABC.
    *   The `generate_content` method should return a fixed, hardcoded string response.
    *   The `count_tokens` method should return the length of the input string.
3.  **Implement a `GeminiContentGenerator`:** Create a concrete class `GeminiContentGenerator` that also implements the ABC.
    *   Its constructor should take an API key.
    *   The `generate_content` method should use the `google.generativeai` library to call the Gemini API.
    *   The `count_tokens` method should also use the library to count tokens.

Please generate the Python code for these classes, focusing on the interface and the wrapper implementation for the Gemini client."

## Module 6: Infrastructure & Deployment (IaC)

**Prompt:**
"You are tasked with setting up the basic containerized environment for the AgenticAI-ADLC project.

1.  **Create a `Dockerfile`:** Write a `Dockerfile` for the main Python application. It should:
    *   Start from a `python:3.11-slim` base image.
    *   Set up a working directory.
    *   Copy `requirements.txt` and install the dependencies.
    *   Copy the rest of the application source code (`src/`).
    *   Define the `CMD` to run the main orchestrator application.
2.  **Create a `docker-compose.yml`:** Write a `docker-compose.yml` file that defines two services:
    *   `orchestrator`: Builds from the `Dockerfile` in the current directory. It should be configured to restart on failure.
    *   `db`: Uses the official `postgres:15` image. It should be configured with a volume to persist data and have environment variables for the default user, password, and database.

Please generate these two files with appropriate content."
