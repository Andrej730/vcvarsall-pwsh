### `vcvarsall.bat` environment in PowerShell

It's annoying that `vcvarsall.bat` environment cannot be simply sourced in PowerShell.
This script outputs `vcvarsall.bat` environment as PowerShell assignments to stdout, which can be applied with `iex`.

Requires `python` to be available in `PATH`.

```powershell
# With uv:
uv tool install git+https://github.com/Andrej730/vcvarsall-pwsh.git
vcvarsall-env | iex

# Without uv:
curl -L https://github.com/Andrej730/vcvarsall-pwsh/raw/master/generate_vcvarsall_env.py | python - | iex

# Confirm it is working.
# Microsoft (R) C/C++ Optimizing Compiler Version 19.44.35217 for x64
cl
```
