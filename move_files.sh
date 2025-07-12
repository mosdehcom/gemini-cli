#!/bin/bash

# Create the new repository directory
mkdir agenticai-adlc

# Move the documentation files
mv docs-orchestrator agenticai-adlc/docs

# Create the source directory
mkdir -p agenticai-adlc/src

# move the .jules directory
mkdir -p agenticai-adlc/.jules
mv .jules/handover_20240524.md agenticai-adlc/.jules/

echo "Files moved successfully. You can now initialize a new git repository in the 'agenticai-adlc' directory."
