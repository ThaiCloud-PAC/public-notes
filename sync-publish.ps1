# Copies Packiko/Publish into content/, then commits and pushes so GitHub Pages rebuilds.
$ErrorActionPreference = 'Stop'
$src = Join-Path $PSScriptRoot '..\..\Packiko\Publish'
$dst = Join-Path $PSScriptRoot 'content'

robocopy $src $dst /MIR /XD .obsidian /NFL /NDL /NJH /NJS | Out-Null
if ($LASTEXITCODE -ge 8) { throw "robocopy failed with exit code $LASTEXITCODE" }

git -C $PSScriptRoot add content
git -C $PSScriptRoot diff --cached --quiet
if ($LASTEXITCODE -eq 0) { Write-Host 'No changes in Publish/'; exit 0 }

git -C $PSScriptRoot commit -m "Sync notes from Packiko/Publish"
git -C $PSScriptRoot push
