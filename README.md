### `vcvarsall.bat` environment in PowerShell

It's annoying that `vcvarsall.bat` environment cannot be simply sourced in PowerShell. 
This script is producing a PowerShell script that can help in this case. 

Requires `python` to be available in `PATH`.


```powershell

curl -L https://raw.githubusercontent.com/Andrej730/vcvarsall-pwsh/refs/heads/master/generate-vcvarsall-env.ps1 -o generate-vcvarsall-env.ps1

# Produce `vcvarsall.bat`-like environment in `vcvarsall-env.ps1`.
pwsh -NoProfile -File .\generate-vcvarsall-env.ps1

# Source the generated environment.
. .\vcvarsall-env.ps1

# Confirm it is working.
# Microsoft (R) C/C++ Optimizing Compiler Version 19.44.35217 for x64
cl
```
