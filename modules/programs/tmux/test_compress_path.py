"""Direct unit tests for the shared path compression utility (compress_path.sh) across Bash and Zsh."""

import subprocess
import os
import pytest

SCRIPT_PATH = os.path.join(os.path.dirname(__file__), "compress_path.sh")


def run_compress_bash(path=None, unset_env=False):
    cmd_parts = []
    if unset_env:
        cmd_parts.append("set -u; unset COMPRESS_PATH_SH;")
    cmd_parts.append(f'source "{SCRIPT_PATH}" &&')
    if path is None:
        cmd_parts.append("compress_path")
    else:
        cmd_parts.append(f'compress_path "{path}"')
    cmd = " ".join(cmd_parts)
    result = subprocess.run(["bash", "-c", cmd], capture_output=True, text=True)
    return result.returncode, result.stdout.strip()


def run_compress_zsh(path=None, nounset=False):
    cmd_parts = []
    if nounset:
        cmd_parts.append("setopt nounset; unset COMPRESS_PATH_SH;")
    cmd_parts.append(f'source "{SCRIPT_PATH}" &&')
    if path is None:
        cmd_parts.append("compress_path")
    else:
        cmd_parts.append(f'compress_path "{path}"')
    cmd = " ".join(cmd_parts)
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    return result.returncode, result.stdout.strip()


@pytest.mark.parametrize("shell_runner", [run_compress_bash, run_compress_zsh])
def test_zero_arguments(shell_runner):
    ret, out = shell_runner(None)
    assert ret == 0
    pwd = os.getcwd()
    _, pwd_compressed = shell_runner(pwd)
    assert out == pwd_compressed


@pytest.mark.parametrize("shell_runner", [run_compress_bash, run_compress_zsh])
def test_empty_argument(shell_runner):
    ret, out = shell_runner("")
    assert ret == 0
    assert out == ""


@pytest.mark.parametrize("shell_runner", [run_compress_bash, run_compress_zsh])
def test_root_slashes(shell_runner):
    ret, out = shell_runner("///")
    assert ret == 0
    assert out == "/"


@pytest.mark.parametrize("shell_runner", [run_compress_bash, run_compress_zsh])
def test_absolute_short_and_long(shell_runner):
    ret, out = shell_runner("/usr")
    assert ret == 0
    assert out == "/usr"

    ret, out = shell_runner("/usr/local/bin/")
    assert ret == 0
    assert out == "/." + ".." + "/bin"


@pytest.mark.parametrize("shell_runner", [run_compress_bash, run_compress_zsh])
def test_home_compression(shell_runner):
    home = os.environ.get("HOME", "/Users/test")
    ret, out = shell_runner(f"{home}/")
    assert ret == 0
    assert out == "~"

    ret, out = shell_runner(f"{home}/projects")
    assert ret == 0
    assert out == "~/projects"

    ret, out = shell_runner(f"{home}/projects/my-app/")
    assert ret == 0
    assert out == "~/." + ".." + "/my-app"


@pytest.mark.parametrize("shell_runner", [run_compress_bash, run_compress_zsh])
def test_named_tilde_prefix(shell_runner):
    ret, out = shell_runner("~otheruser/projects/my-app/")
    assert ret == 0
    assert out == "~otheruser/." + ".." + "/my-app"


@pytest.mark.parametrize("shell_runner", [run_compress_bash, run_compress_zsh])
def test_citc_paths(shell_runner):
    ret, out = shell_runner("/google/src/cloud/daehyeok/my-ws/google3/")
    assert ret == 0
    assert out == "(my-ws:google3)"

    ret, out = shell_runner("/google/src/cloud/daehyeok/my-ws/google3/devtools/devassist")
    assert ret == 0
    assert out == "(my-ws:google3)//." + ".." + "/devassist"


def test_strict_nounset_isolation():
    ret, out = run_compress_bash("/usr/local/bin", unset_env=True)
    assert ret == 0
    assert out == "/." + ".." + "/bin"

    ret, out = run_compress_zsh("/usr/local/bin", nounset=True)
    assert ret == 0
    assert out == "/." + ".." + "/bin"
