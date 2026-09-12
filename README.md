# Dell Hackathon Stuff

Portable workspace for the Dell hackathon.

## Current state

This repository currently contains the migration scaffold only. No application
source code or project-specific dependency manifest was present in the original
workspace when it was connected to GitHub.

The source machine had:

- Windows x64, build 26200.9445
- Git 2.48.1
- Visual Studio Code 1.135.0
- .NET SDK 9.0.200
- Java 8

Node 24.19.0 and pnpm 11.19.0 were supplied by Codex's private runtime cache,
not installed as normal system tools. Python, Conda, uv, Docker, GitHub CLI,
winget, and npm were not available on the command line.

## Move to the hackathon machine

Install Git, then run:

```powershell
git clone https://github.com/Francis2333/dell-hackathon-stuff.git
Set-Location dell-hackathon-stuff
powershell -ExecutionPolicy Bypass -File .\scripts\check-environment.ps1
```

Copy application source files into this repository on the source machine,
commit them, and push. On the hackathon machine, use `git pull` to retrieve
them.

Do not commit `.env` files, access tokens, private keys, virtual environments,
`node_modules`, build output, large datasets, or model weights. Create an
`.env.example` containing variable names only and transfer real secret values
through an approved secret manager.

## Making the application reproducible

Commit the dependency definition appropriate to the project:

- Python: `pyproject.toml` plus a lock file, or `requirements.txt`
- Node.js: `package.json` plus `package-lock.json` or `pnpm-lock.yaml`
- .NET: project files plus `global.json`
- Containers: `Dockerfile` and, when needed, `compose.yaml`

The environment checker reports which manifests and command-line tools are
available without installing or changing anything.

