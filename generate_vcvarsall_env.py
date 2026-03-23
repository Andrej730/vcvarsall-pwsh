import os
import subprocess
from pathlib import Path


def main() -> None:
    program_files = os.getenv("ProgramFiles(x86)")
    assert program_files is not None
    vswhere = Path(program_files) / r"Microsoft Visual Studio\Installer\vswhere.exe"

    vs_path = subprocess.check_output(
        [str(vswhere), "-property", "installationPath"], text=True
    ).strip()
    vcvars = Path(vs_path) / r"VC\Auxiliary\Build\vcvarsall.bat"

    vcvars_env = Path("vcvarsall-env.ps1")

    # Run vcvarsall.bat in a minimal environment and capture the resulting env vars.
    minimal_env: dict[str, str] = {}
    # If this is missing, `vcvarsall.bat` is missing some paths (e.g. `rc` is not available).
    minimal_env["Path"] = r"C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\system32"
    # Fixes: Internal Windows PowerShell error. Loading managed Windows PowerShell failed with error 8009001d.
    minimal_env["SystemRoot"] = r"C:\Windows"

    output = subprocess.check_output(
        f'cmd.exe /c call "{vcvars}" x64 > nul && set',
        env=minimal_env,
        text=True,
    )

    lines: list[str] = []
    for line in output.splitlines():
        pos = line.find("=")
        assert pos != -1
        var_name = line[:pos]
        value = line[pos + 1 :]
        new_line = f'$env:{var_name}="{value}"'
        if var_name.upper() == "PATH":
            new_line += ' + ";$env:Path"'
        lines.append(new_line)

    vcvars_env.write_text("\n".join(lines) + "\n")
    print(f"Run `. .\\{vcvars_env}` to set up `vcvarsall` environment.")


if __name__ == "__main__":
    main()
