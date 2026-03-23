### `vcvarsall.bat` environment in PowerShell

It's annoying that `vcvarsall.bat` environment cannot be simply sourced in PowerShell. 
This script is producing a PowerShell script that can help in this case. 

Requires `python` to be available in `PATH`.


```powershell

curl -L https://github.com/Andrej730/vcvarsall-pwsh/raw/master/generate_vcvarsall_env.py -o generate_vcvarsall_env.py

# Produce `vcvarsall.bat`-like environment in `vcvarsall-env.ps1`.
python .\generate_vcvarsall_env.py

# Source the generated environment.
. .\vcvarsall-env.ps1

# Confirm it is working.
# Microsoft (R) C/C++ Optimizing Compiler Version 19.44.35217 for x64
cl
```
