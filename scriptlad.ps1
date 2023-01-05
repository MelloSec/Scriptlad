[cmdletbinding()]
param (
  [Parameter(
    Position = 0,
    HelpMessage = "The script to run. If not specified, the user will be prompted for it.",
    ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true
  )]
  [string] $Script,

  [Parameter(
    HelpMessage = "The arguments to pass to the script. If not specified, no arguments will be passed.",
    ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true
  )]
  [string] $Arguments,

  [Parameter(
    HelpMessage = "The input file or '-n' for no input. If not specified, the user will be prompted for it.",
    ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true
  )]
  [string] $Input,

  [Parameter(
    HelpMessage = "The output file. If not specified, the user will be prompted for it.",
    ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true
  )]
  [string] $Output
)

# Prompt the user for the script if it's not set
if (!$Script) {
  $Script = Read-Host "Enter the script" -Completer (Get-Command).Name
}

# Prompt the user for the input file if it's not set
if (!$Input) {
  $Input = Read-Host "Enter the input file or '-n' for no input" -Completer "*.txt","-n"
}

# Prompt the user for the output file if it's not set
if (!$Output) {
  $Output = Read-Host "Enter the output file" -Completer "*.txt"
}

# Clear the output file
"" | Set-Content $Output

# Read the input file line by line
$Lines = Get-Content $Input
foreach ($Line in $Lines) {
  # Check if the script ends in ".sh"
  if ($Script -like "*.sh") {
    # Run the script with wsl and append the output to the output file
    & wsl "$Script" "$Arguments" "$Line" | Out-File -Append $Output
  # Check if the script ends in ".bat" or ".cmd"
} elseif ($Script -like "*.bat" -or $Script -like "*.cmd") {
  # Run the script with cmd.exe and append the output to the output file
  & cmd.exe /c "$Script" "$Arguments" "$Line" | Out-File -Append $Output
# Check if the script ends in ".ps1"
} elseif ($Script -like "*.ps1") {
  # Run the script with pwsh and append the output to the output file
  & pwsh "$Script" "$Arguments" "$Line" | Out-File -Append $Output
# Check if the script ends in ".py"
} elseif ($Script -like "*.py") {
  # Run the script with python and append the output to the output file
  & python "$Script" "$Arguments" "$Line" | Out-File -Append $Output
# Check if the script ends in ".rb"
} elseif ($Script -like "*.rb") {
  # Run the script with ruby and append the output to the output file
  & ruby "$Script" "$Arguments" "$Line" | Out-File -Append $Output
} else {
  # Run the script with PowerShell and append the output to the output file
  & powershell "$Script" "$Arguments" "$Line" | Out-File -Append $Output
}
}

# Check if the input is set
if ($Input) {
# Check if the script ends in ".sh"
if ($Script -like "*.sh") {
  # Run the script with wsl and append the output to the output file
  & wsl "$Script" "$Arguments" "$Input" | Out-File -Append $Output
# Check if the script ends in ".bat" or ".cmd"
} elseif ($Script -like "*.bat" -or $Script -like "*.cmd") {
  # Run the script with cmd.exe and append the output to the output file
  & cmd.exe /c "$Script" "$Arguments" "$Input" | Out-File -Append $Output
# Check if the script ends in ".ps1"
} elseif ($Script -like "*.ps1") {
  # Run the script with pwsh and append the output to the output file
  & pwsh "$Script" "$Arguments" "$Input" | Out-File -Append $Output
# Check if the script ends in ".py"
} elseif ($Script -like "*.py") {
  # Run the script with python and append the output to the output file
  & python "$Script" "$Arguments" "$Input" | Out-File -Append $Output
# Check if the script ends in ".rb"
} elseif ($Script -like "*.rb") {
  # Run the script with ruby and append the output to the output file
  & ruby "$Script" "$Arguments" "$Input" | Out-File -Append $Output
} else {
  # Run the script with PowerShell and append the output to the output file
  & powershell "$Script" "$Arguments" "$Input" | Out-File -Append $Output
}
}
