# `vswhere` path seems to be consistent.
$program_files = [Environment]::GetEnvironmentVariable("ProgramFiles(x86)")
$vswhere = "$program_files\Microsoft Visual Studio\Installer\vswhere.exe"
$vs_path = & "$vswhere" -property installationPath
$vcvars = "$vs_path\VC\Auxiliary\Build\vcvarsall.bat"

$vcvars_env = "vcvarsall-env.ps1"
# Save it, as we about to obliterate environment.
$python = (Get-Command python.exe).Source

# Clean existing environment variables to clearly separate `vcvarsall.bat` products.
$allVars = Get-ChildItem env: | Select-Object -ExpandProperty Name
foreach ($var in $allVars) {
    Remove-Item Env:$var
}

# Create minimal environment.
# vcvarasall.bat is using `powershell`.
$env:Path = "C:\Windows\System32\WindowsPowerShell\v1.0\"
# If this is missing, `vcvarsall.bat` is missing some paths (e.g. `rc` is not available).
$env:Path += ";C:\Windows\system32"
# `powershell` is crashing without it.
$env:SystemRoot = "C:\Windows"

# Debug.
# & "C:\Windows\System32\cmd.exe" /c "set && `"$vcvars`" x64 && set && cl"

& "C:\Windows\System32\cmd.exe" /c "`"$vcvars`" x64 > nul && set > $vcvars_env"

$code = @"
from pathlib import Path
env_file = Path(r'$vcvars_env')
new_text = ""
for line in env_file.read_text(encoding="utf-8").splitlines():
    var_name, _, value = line.partition('=')
    pos = line.find('=')
    assert pos != -1
    new_line = f'`$env:{var_name}="{value}"'
    if var_name == "Path":
        new_line += " + `$env:Path"
    new_text += f"{new_line}\n"
env_file.write_text(new_text)
"@

$code | & "$python" -

Write-Output "Run ``. .\$vcvars_env`` to set up ``vcvarsall`` environment."
