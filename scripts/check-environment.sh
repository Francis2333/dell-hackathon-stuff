#!/usr/bin/env bash

set -u

printf 'System\n'
if [[ -r /etc/os-release ]]; then
  # The values in this system-owned file describe the distribution.
  . /etc/os-release
  printf '  OS: %s\n' "${PRETTY_NAME:-unknown}"
else
  printf '  OS: %s\n' "$(uname -s)"
fi
printf '  Kernel: %s\n' "$(uname -r)"
printf '  Architecture: %s\n' "$(uname -m)"
printf '  Shell: %s\n' "${SHELL:-unknown}"

print_tool() {
  local label="$1"
  local command_name="$2"
  shift 2

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf '  [missing] %s\n' "$label"
    return
  fi

  local version
  version="$($command_name "$@" 2>&1 | head -n 1)"
  printf '  [found]   %s: %s\n' "$label" "$version"
}

printf '\nTools\n'
print_tool 'Git' git --version
print_tool 'Python' python3 --version
print_tool 'pip' pip3 --version
print_tool 'Conda' conda --version
print_tool 'uv' uv --version
print_tool 'Node.js' node --version
print_tool 'npm' npm --version
print_tool 'pnpm' pnpm --version
print_tool '.NET' dotnet --version
print_tool 'Java' java -version
print_tool 'Docker' docker --version

printf '\nDependency manifests\n'
found_manifest=0
for manifest in \
  pyproject.toml requirements.txt uv.lock environment.yml \
  package.json package-lock.json pnpm-lock.yaml \
  global.json Dockerfile compose.yaml; do
  if [[ -f "$manifest" ]]; then
    printf '  [found] %s\n' "$manifest"
    found_manifest=1
  fi
done

if [[ "$found_manifest" -eq 0 ]]; then
  printf '  No project-specific dependency manifest found yet.\n'
fi

printf '\nSuggested restore commands\n'
[[ -f uv.lock ]] && printf '  Python/uv: uv sync --frozen\n'
[[ -f requirements.txt ]] && printf '  Python/pip: python3 -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt\n'
[[ -f pnpm-lock.yaml ]] && printf '  Node/pnpm: corepack enable && pnpm install --frozen-lockfile\n'
[[ -f package-lock.json ]] && printf '  Node/npm: npm ci\n'
if compgen -G '*.sln' >/dev/null || compgen -G '*.csproj' >/dev/null; then
  printf '  .NET: dotnet restore\n'
fi
[[ -f Dockerfile ]] && printf '  Docker: docker build -t dell-hackathon .\n'

printf '\nGit\n'
if command -v git >/dev/null 2>&1; then
  git status --short --branch
  git remote -v
fi
