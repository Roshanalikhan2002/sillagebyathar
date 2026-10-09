# Regenerate the homepage's complete CSS copy after editing assets/base.css.
# Copy verbatim to preserve nested rules, media queries and declaration order.
$themeRoot = Split-Path -Parent $PSScriptRoot
$baseSource = Join-Path $themeRoot 'assets/base.css'
$inlineTarget = Join-Path $themeRoot 'snippets/base-styles-inline.liquid'
$baseContent = [System.IO.File]::ReadAllText($baseSource)
if ($baseContent.Contains('{{') -or $baseContent.Contains('{%') -or $baseContent.Contains('</style')) {
    throw 'Base CSS contains markup that cannot be safely rendered in a Liquid style element.'
}
[System.IO.File]::WriteAllText($inlineTarget, $baseContent, [System.Text.UTF8Encoding]::new($false))
