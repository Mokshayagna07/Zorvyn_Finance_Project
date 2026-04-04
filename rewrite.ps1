$seqEditorPath = "$PWD\seq_editor.ps1"
$editorPath = "$PWD\msg_editor.ps1"

@"
`$content = Get-Content `$args[0]
`$content = `$content -replace '^pick ', 'reword '
`$content | Set-Content `$args[0]
"@ | Out-File -FilePath $seqEditorPath -Encoding utf8

@"
`$content = Get-Content `$args[0]
`$content = `$content -replace 'feat\(phase-\d+\):\s*', 'feat: '
`$content | Set-Content `$args[0]
"@ | Out-File -FilePath $editorPath -Encoding utf8

$env:GIT_SEQUENCE_EDITOR = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$seqEditorPath`""
$env:GIT_EDITOR = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$editorPath`""

Write-Host "Starting Git Rebase..."
git rebase -i --root

Write-Host "Adding Phase 4 and 5 changes..."
git add .
git commit -m "feat: Implement business logic and expose REST Controllers"

Write-Host "Force pushing to GitHub..."
git push -u origin main --force

Write-Host "Cleaning up scripts..."
Remove-Item $seqEditorPath -ErrorAction SilentlyContinue
Remove-Item $editorPath -ErrorAction SilentlyContinue
Remove-Item $MyInvocation.MyCommand.Path -ErrorAction SilentlyContinue
