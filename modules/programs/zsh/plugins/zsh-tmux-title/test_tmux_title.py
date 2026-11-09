"""Tests for the zsh-tmux-title plugin."""

import subprocess
import os
import pytest

SCRIPT_PATH = os.path.join(os.path.dirname(__file__), "tmux-title.zsh")

def run_zsh_compress(path):
    cmd = f'source "{SCRIPT_PATH}" && _tmux_compress_path "{path}"'
    result = subprocess.run(
        ["zsh", "-c", cmd],
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()

def test_zsh_with_path():
    home = os.environ.get("HOME", "/Users/test")
    path = f"{home}/projects/my-app"
    expected_path = "~/." + ".." + "/my-app"
    assert run_zsh_compress(path) == expected_path

def test_zsh_with_shortened_path():
    home = os.environ.get("HOME", "/Users/test")
    path = f"{home}/extremely/long/path/to/something/deep"
    expected_path = "~/." + ".." + "/deep"
    assert run_zsh_compress(path) == expected_path

def test_citc_behavior_standard():
    path = "/google/src/cloud/daehyeok/my-ws/google3/devtools/devassist"
    expected = "(my-ws:google3)//." + ".." + "/devassist"
    assert run_zsh_compress(path) == expected

def test_citc_behavior_short():
    path = "/google/src/cloud/daehyeok/my-ws/google3"
    expected = "(my-ws:google3)"
    assert run_zsh_compress(path) == expected

def test_citc_behavior_deep():
    path = "/google/src/cloud/daehyeok/my-ws/google3/java/com/google/devtools/devassist/gemini"
    expected = "(my-ws:java)//." + ".." + "/gemini"
    assert run_zsh_compress(path) == expected

def test_citc_refinement_javatests():
    path = "/google/src/cloud/daehyeok/firover/google3/javatests/com/google/firover"
    expected = "(firover:javatests)//." + ".." + "/firover"
    assert run_zsh_compress(path) == expected

def test_citc_refinement_blaze_bin():
    path = "/google/src/cloud/daehyeok/my-ws/google3/blaze-bin/path/to/app"
    expected = "(my-ws:blaze-bin)//." + ".." + "/app"
    assert run_zsh_compress(path) == expected

def test_citc_refinement_short_label():
    path = "/google/src/cloud/daehyeok/ws/google3"
    expected = "(ws:google3)"
    assert run_zsh_compress(path) == expected

def test_absolute_path_compression():
    path = "/usr/lib/systemd"
    expected = "/." + ".." + "/systemd"
    assert run_zsh_compress(path) == expected

def test_precmd_escape_sequence():
    cmd = f'source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_precmd'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert "\x1bk" in result.stdout
    assert "\x1b\\" in result.stdout

def test_preexec_escape_sequence():
    cmd = f'source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_preexec "FOO=bar sudo vim file.txt"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1bkvim\x1b\\"

def test_preexec_escape_sequence_complex():
    cmd = f'source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_preexec "sudo -u root env FOO=bar nvim file.txt"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1bknvim\x1b\\"

def test_preexec_escape_sequence_full_path():
    cmd = f'source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_preexec "nocorrect /usr/bin/git status"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1bkgit\x1b\\"

def test_preexec_escape_sequence_typo_fallback():
    cmd = f'source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_preexec "typo_cmd arg1 arg2"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1bktypo_cmd\x1b\\"

def test_emulation_isolation_ksh_arrays():
    home = os.environ.get("HOME", "/Users/test")
    path = f"{home}/projects/my-app"
    expected_path = "~/." + ".." + "/my-app"
    cmd = f'setopt ksh_arrays && source "{SCRIPT_PATH}" && _tmux_compress_path "{path}"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout.strip() == expected_path

def test_emulation_isolation_sh_word_split():
    cmd = f'setopt sh_word_split && source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_preexec "sudo -u root nvim file.txt"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1bknvim\x1b\\"

def test_preexec_option_arg_skipping_valid_binary():
    # 'sh' is a valid binary in PATH. Without option argument skipping for '-u',
    # preexec would erroneously extract 'sh' instead of 'git'.
    cmd = f'source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_preexec "sudo -u sh git status"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1bkgit\x1b\\"

def test_preexec_long_option_arg_skipping():
    cmd = f'source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_preexec "sudo --user sh git status"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1bkgit\x1b\\"

def test_compress_path_unsafe_home():
    # When HOME is '/', replacing $HOME with '~' would turn '/usr/bin' into '~usr/bin'.
    # The guard ensures it falls back to standard absolute path compression '/.../bin'.
    cmd = f'HOME=/ source "{SCRIPT_PATH}" && _tmux_compress_path "/usr/bin"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    expected = "/." + ".." + "/bin"
    assert result.stdout.strip() == expected

def test_citc_trailing_slash():
    path = "/google/src/cloud/daehyeok/my-ws/google3/devtools/devassist/"
    expected = "(my-ws:google3)//." + ".." + "/devassist"
    assert run_zsh_compress(path) == expected

def test_home_trailing_slash():
    home = os.environ.get("HOME", "/Users/test")
    path = f"{home}/projects/my-app/"
    expected = "~/." + ".." + "/my-app"
    assert run_zsh_compress(path) == expected

def test_empty_arg():
    assert run_zsh_compress("") == ""

def test_named_tilde_prefix():
    path = "~otheruser/projects/app"
    expected = "~otheruser/." + ".." + "/app"
    assert run_zsh_compress(path) == expected

def test_nounset_compatibility():
    # Verify tmux-title.zsh sources and runs without error under setopt nounset
    cmd = f'setopt nounset; unset COMPRESS_PATH_SH; source "{SCRIPT_PATH}" && _tmux_compress_path "/usr/lib/systemd"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.returncode == 0
    assert "/." + ".." + "/systemd" in result.stdout

def test_dynamic_fallback_recovery():
    cmd = f'source "{SCRIPT_PATH}"; unfunction compress_path; unset COMPRESS_PATH_SH; _tmux_compress_path "/usr/lib/systemd"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.returncode == 0
    assert "/." + ".." + "/systemd" in result.stdout.strip()

def test_unresolvable_compress_path_graceful_fallback():
    # If compress_path is missing and resolution fails completely,
    # _tmux_compress_path should exit 0 and output the uncompressed path rather than command not found error.
    cmd = f'source "{SCRIPT_PATH}"; unfunction compress_path 2>/dev/null; COMPRESS_PATH_SH=/nonexistent ZDOTDIR=/nonexistent HOME=/nonexistent _TMUX_TITLE_RAW_DIR=/nonexistent _TMUX_TITLE_REAL_DIR=/nonexistent _tmux_compress_path "/tmp/my_folder"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.returncode == 0
    assert "command not found" not in result.stderr.lower()
    assert "/tmp/my_folder" in result.stdout.strip()

def test_corrupted_compress_path_sh_retry(tmp_path):
    # If COMPRESS_PATH_SH points to a dummy script that does NOT define compress_path,
    # _tmux_compress_path should detect this, unset COMPRESS_PATH_SH, and re-run discovery to self-heal.
    dummy_script = tmp_path / "dummy.sh"
    dummy_script.write_text("# empty script\n")
    cmd = f'source "{SCRIPT_PATH}"; unfunction compress_path 2>/dev/null; COMPRESS_PATH_SH="{dummy_script}" _tmux_compress_path "/usr/lib/systemd"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.returncode == 0
    assert "/." + ".." + "/systemd" in result.stdout.strip()

def test_tmux_guard_outside_session():
    # Outside tmux/Rex, hooks should NOT be registered into precmd_functions / preexec_functions
    cmd = f'unset TMUX REX_BLOCK TERM_PROGRAM; source "{SCRIPT_PATH}"; echo "precmd=${{precmd_functions[(r)_tmux_window_title_precmd]:-none}} preexec=${{preexec_functions[(r)_tmux_window_title_preexec]:-none}}"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.returncode == 0
    assert "precmd=none" in result.stdout
    assert "preexec=none" in result.stdout

def test_tmux_guard_inside_session():
    # Inside a tmux session, hooks SHOULD be registered into precmd_functions and preexec_functions
    cmd = f'export TMUX="1"; source "{SCRIPT_PATH}"; echo "precmd=${{precmd_functions[(r)_tmux_window_title_precmd]:-none}} preexec=${{preexec_functions[(r)_tmux_window_title_preexec]:-none}}"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.returncode == 0
    assert "precmd=_tmux_window_title_precmd" in result.stdout
    assert "preexec=_tmux_window_title_preexec" in result.stdout

def test_preexec_escape_sequence_path_with_command_arg():
    # Regression test: when command is a path (/usr/bin/git) and argument (diff) is also a valid command in PATH,
    # preexec must identify git as the command rather than skipping /usr/bin/git and matching diff.
    cmd = f'source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_preexec "nocorrect /usr/bin/git diff"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1bkgit\x1b\\"

def test_preexec_escape_sequence_relative_path_with_command_arg():
    cmd = f'source "{SCRIPT_PATH}" && TMUX=1 _tmux_window_title_preexec "./myscript.sh ls"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1bkmyscript.sh\x1b\\"

def test_precmd_rex_osc_title():
    cmd = f'unset TMUX; source "{SCRIPT_PATH}" && REX_BLOCK=block:x _tmux_window_title_precmd'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout.startswith("\x1b]2;")
    assert result.stdout.endswith("\x07")

def test_preexec_rex_osc_title():
    cmd = f'unset TMUX; source "{SCRIPT_PATH}" && REX_BLOCK=block:x _tmux_window_title_preexec "sudo vim file.txt"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == "\x1b]2;vim\x07"

def test_no_title_outside_tmux_and_rex():
    cmd = f'unset TMUX REX_BLOCK TERM_PROGRAM; source "{SCRIPT_PATH}" && _tmux_window_title_precmd'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert result.stdout == ""

def test_rex_guard_registers_hooks():
    cmd = f'unset TMUX; export REX_BLOCK=block:x; source "{SCRIPT_PATH}"; echo "precmd=${{precmd_functions[(r)_tmux_window_title_precmd]:-none}}"'
    result = subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)
    assert "precmd=_tmux_window_title_precmd" in result.stdout

def _rex_run(script):
    cmd = f'unset TMUX; export REX_BLOCK=block:x; source "{SCRIPT_PATH}"; {script}'
    return subprocess.run(["zsh", "-c", cmd], capture_output=True, text=True)

def test_rex_status_working():
    r = _rex_run('_rex_status_preexec "make all" 2>/dev/null')
    assert r.stdout == "\x1b]7501;state=working:app=make:msg=bWFrZSBhbGw=\x1b\\"

def test_rex_status_ignored_program_not_working():
    r = _rex_run('_rex_status_preexec "nvim foo"')
    assert r.stdout == ""

def test_rex_status_short_command_clears():
    r = _rex_run('_rex_status_preexec "make" >/dev/null; true; _rex_status_precmd')
    assert r.stdout == "\x1b]7501;state=clear\x1b\\"

def test_rex_status_long_command_done():
    r = _rex_run('_rex_status_preexec "make" >/dev/null; _REX_STATUS_START=$((EPOCHREALTIME-30)); true; _rex_status_precmd')
    assert r.stdout.startswith("\x1b]7501;state=done:app=make:msg=")

def test_rex_status_long_command_error():
    r = _rex_run('_rex_status_preexec "make" >/dev/null; _REX_STATUS_START=$((EPOCHREALTIME-30)); (exit 2); _rex_status_precmd')
    assert r.stdout.startswith("\x1b]7501;state=error:app=make:msg=")

def test_rex_status_precmd_without_command_is_silent():
    r = _rex_run('_rex_status_precmd')
    assert r.stdout == ""

def test_rex_title_error_mark():
    r = _rex_run('_rex_status_preexec "make" >/dev/null; (exit 3); _rex_status_precmd >/dev/null; _tmux_window_title_precmd')
    assert r.stdout.startswith("\x1b]2;❌3 ")

def test_rex_title_no_mark_on_success_or_interrupt():
    r = _rex_run('_rex_status_preexec "make" >/dev/null; (exit 130); _rex_status_precmd >/dev/null; _tmux_window_title_precmd')
    assert "❌" not in r.stdout
    r = _rex_run('_rex_status_preexec "make" >/dev/null; true; _rex_status_precmd >/dev/null; _tmux_window_title_precmd')
    assert "❌" not in r.stdout
