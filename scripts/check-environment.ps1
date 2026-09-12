[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'

Write-Host 'System'
Write-Host "  OS: $([System.Environment]::OSVersion.VersionString)"
Write-Host "  PowerShell: $($PSVersionTable.PSVersion)"
Write-Host "  Architecture: $([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture)"

Write-Host "`nTools"
$commands = @(
    @{ Name = 'Git'; Command = 'git'; Arguments = @('--version') },
    @{ Name = 'Python'; Command = 'python'; Arguments = @('--version') },
    @{ Name = 'Python launcher'; Command = 'py'; Arguments = @('--version') },
    @{ Name = 'Conda'; Command = 'conda'; Arguments = @('--version') },
    @{ Name = 'uv'; Command = 'uv'; Arguments = @('--version') },
    @{ Name = 'Node.js'; Command = 'node'; Arguments = @('--version') },
    @{ Name = 'npm'; Command = 'npm'; Arguments = @('--version') },
    @{ Name = 'pnpm'; Command = 'pnpm'; Arguments = @('--version') },
    @{ Name = '.NET'; Command = 'dotnet'; Arguments = @('--version') },
    @{ Name = 'Java'; Command = 'java'; Arguments = @('-version') },
    @{ Name = 'Docker'; Command = 'docker'; Arguments = @('--version') }
)

foreach ($item in $commands) {
    $found = Get-Command $item.Command -ErrorAction SilentlyContinue
    if (-not $found) {
        Write-Host "  [missing] $($item.Name)"
        continue
    }

    $version = & $item.Command @($item.Arguments) 2>&1 | Select-Object -First 1
    Write-Host "  [found]   $($item.Name): $version"
}

Write-Host "`nDependency manifests"
$manifests = @(
    'pyproject.toml',
    'requirements.txt',
    'uv.lock',
    'environment.yml',
    'package.json',
    'package-lock.json',
    'pnpm-lock.yaml',
    'global.json',
    'Dockerfile',
    'compose.yaml'
)

$foundManifest = $false
foreach ($manifest in $manifests) {
    if (Test-Path -LiteralPath $manifest) {
        Write-Host "  [found] $manifest"
        $foundManifest = $true
    }
}

if (-not $foundManifest) {
    Write-Host '  No project-specific dependency manifest found yet.'
}

Write-Host "`nGit"
if (Get-Command git -ErrorAction SilentlyContinue) {
    git status --short --branch
    git remote -v
}
