param([string]$DartPath = 'dart')
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$guideRoot = Join-Path $projectRoot 'docs/usage'
$generatedRoot = Join-Path $projectRoot '.dart_tool'
New-Item -ItemType Directory -Force $generatedRoot | Out-Null
$generated = Join-Path $generatedRoot 'usage_examples_check.dart'
$blocks = [Collections.Generic.List[string]]::new()
$blocks.Add('// Generated from docs/usage. Do not edit.')
$blocks.Add('// ignore_for_file: sort_child_properties_last')
$blocks.Add("import 'package:flutter/material.dart';")
$blocks.Add("import 'package:lemon_ui/lemon_ui.dart';")
$index = 0
$applicationCount = 0
foreach ($file in Get-ChildItem -LiteralPath $guideRoot -Filter '*.md') {
  $source = [IO.File]::ReadAllText($file.FullName)
  foreach ($link in [regex]::Matches($source, '\]\(([^)#]+)(?:#[^)]*)?\)')) {
    $target = $link.Groups[1].Value
    if ($target -match '^[a-z]+:' -or $target.StartsWith('/')) { continue }
    $resolved = Join-Path $file.DirectoryName $target
    if (-not (Test-Path -LiteralPath $resolved)) {
      throw "Broken link in $($file.Name): $target"
    }
  }
  foreach ($match in [regex]::Matches($source, '(?s)~~~dart\r?\n(.*?)\r?\n~~~')) {
    $code = $match.Groups[1].Value
    if ($code.Contains('void main()')) {
      $applicationCount++
      $blocks.Add([regex]::Replace($code, "(?m)^import .*;\r?\n", ''))
    } else {
      $index++
      $blocks.Add("// $($file.Name), expression $index")
      $blocks.Add("Widget example$index(BuildContext context) => $code;")
    }
  }
}
[IO.File]::WriteAllText($generated, ($blocks -join [Environment]::NewLine), [Text.UTF8Encoding]::new($false))
Write-Output "Checked local links. Analyzing $index expressions and $applicationCount full application(s)."
Push-Location $projectRoot
try {
  & $DartPath analyze $generated
  $analysisExit = $LASTEXITCODE
} finally {
  Pop-Location
}
exit $analysisExit
