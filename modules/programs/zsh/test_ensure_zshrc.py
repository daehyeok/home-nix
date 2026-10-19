import os
import subprocess
from pathlib import Path

SCRIPT_PATH = Path(__file__).parent / "ensure_zshrc.sh"


def test_creates_zshrc_when_missing(tmp_path):
    zshrc = tmp_path / ".zshrc"
    res = subprocess.run(["bash", str(SCRIPT_PATH), str(zshrc)], capture_output=True, text=True)
    assert res.returncode == 0
    assert zshrc.is_file()
    content = zshrc.read_text()
    assert "# Home Manager Zsh Configuration Loader" in content
    assert 'source "$HOME/.config/zsh/.zshrc"' in content


def test_prepends_when_zshrc_has_existing_tool_content(tmp_path):
    zshrc = tmp_path / ".zshrc"
    zshrc.write_text('# Added by tool\nexport PATH="$HOME/.tool/bin:$PATH"\n')

    res = subprocess.run(["bash", str(SCRIPT_PATH), str(zshrc)], capture_output=True, text=True)
    assert res.returncode == 0
    content = zshrc.read_text()
    assert content.index('source "$HOME/.config/zsh/.zshrc"') < content.index('export PATH="$HOME/.tool/bin:$PATH"')


def test_idempotent_when_already_sourced(tmp_path):
    zshrc = tmp_path / ".zshrc"
    subprocess.run(["bash", str(SCRIPT_PATH), str(zshrc)], check=True)
    zshrc.write_text(zshrc.read_text() + '\nexport MY_VAR="hello"\n')
    before = zshrc.read_text()

    subprocess.run(["bash", str(SCRIPT_PATH), str(zshrc)], check=True)
    assert zshrc.read_text() == before


def test_mutual_sourcing_no_infinite_recursion(tmp_path):
    config_zsh = tmp_path / ".config" / "zsh"
    config_zsh.mkdir(parents=True)
    config_zshrc = config_zsh / ".zshrc"
    user_zshrc = tmp_path / ".zshrc"

    subprocess.run(["bash", str(SCRIPT_PATH), str(user_zshrc)], check=True)
    with user_zshrc.open("a") as f:
        f.write('\nORDER+=("user")\n')

    config_zshrc.write_text(
        'ORDER+=("hm")\n'
        'if [[ -z "${_HM_ZSHRC_LOADING:-}" && -f "$HOME/.zshrc" ]]; then\n'
        '  _HM_ZSHRC_LOADING=1\n'
        '  source "$HOME/.zshrc"\n'
        '  unset _HM_ZSHRC_LOADING\n'
        'fi\n'
    )

    env = os.environ.copy()
    env["HOME"] = str(tmp_path)

    # Case 1: Zsh starts via ~/.config/zsh/.zshrc
    r1 = subprocess.run(
        ["zsh", "-c", 'ORDER=(); source "$HOME/.config/zsh/.zshrc"; echo "${ORDER[*]}"'],
        env=env,
        capture_output=True,
        text=True,
        check=True,
    )
    assert r1.stdout.strip() == "hm user"

    # Case 2: User runs `source ~/.zshrc` directly
    r2 = subprocess.run(
        ["zsh", "-c", 'ORDER=(); source "$HOME/.zshrc"; echo "${ORDER[*]}"'],
        env=env,
        capture_output=True,
        text=True,
        check=True,
    )
    assert r2.stdout.strip() == "hm user"
