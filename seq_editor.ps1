$content = Get-Content $args[0]
$content = $content -replace '^pick ', 'reword '
$content | Set-Content $args[0]
