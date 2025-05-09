# lib/

This folder is for custom, reusable components (local libraries).

Each subfolder in `lib/` should contain a self-contained module, optionally with its own `src/` and `include/` structure. 
These can be reused across multiple projects or contribute to separation of concerns in your codebase.

## Guidelines

- Each library must be in its own subfolder.
- Structure each library like a mini-project:
    - `lib/<name>/src/...`
    - `lib/<name>/include/...`
    or for smaller libs:
    - `lib/<name>/...`

## Example structure

lib/
├── Hardware/
│   └── CMotor.hpp
│   └── CMotor.cpp
│   └── CSensor.cpp
│   └── CSensor.cpp
├── Framework/
│   └── CSemaphore.hpp
│   └── CSemaphore.cpp
│   └── CSocket.cpp
│   └── CSocket.cpp