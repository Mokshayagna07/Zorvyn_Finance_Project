$content = Get-Content $args[0]
$content = $content -replace 'feat\(phase-\d+\):\s*', 'feat: '
$content | Set-Content $args[0]
