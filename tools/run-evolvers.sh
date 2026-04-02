#!/bin/bash
# run-evolver.sh — wrapper for evolver with correct env vars
cd ~/.openclaw/workspace/skills/capability-evolver
export EVOLVER_USE_PARENT_GIT=true
export EVOLVE_STRATEGY=balanced
export EVOLVE_LOAD_MAX=2.0
node index.js 2>&1
