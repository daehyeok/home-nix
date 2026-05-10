"""Tests for the window_text.sh tmux window title formatter."""

import subprocess
import os
import pytest

SCRIPT_PATH = os.path.join(os.path.dirname(__file__), "window_text.sh")

def run_script(pane_title, window_name, pane_current_path=""):
    result = subprocess.run(
        ["bash", SCRIPT_PATH, pane_title, window_name, pane_current_path],
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()

def test_existing_behavior_nvim():
    #  is the icon for nvim
    assert " nvim" in run_script("nvim", "zsh")

def test_existing_behavior_git():
    #  is the icon for git
    assert " git" in run_script("git", "zsh")

def test_new_behavior_zsh_with_path():
    # When base_name is zsh, it should show icon + compressed path
    # Icon for zsh is 
    home = os.environ.get("HOME", "/Users/test")
    path = f"{home}/projects/my-app"
    expected_path = "~/.../my-app"
    output = run_script("zsh", "zsh", path)
    assert "" in output
    assert expected_path in output
    assert "zsh" not in output # Should show path, not "zsh"

def test_new_behavior_zsh_with_shortened_path():
    # Testing more aggressive compression
    home = os.environ.get("HOME", "/Users/test")
    path = f"{home}/extremely/long/path/to/something/deep"
    expected_path = "~/.../deep"
    output = run_script("zsh", "zsh", path)
    assert "" in output
    assert expected_path in output

def test_citc_behavior_standard():
    path = "/google/src/cloud/daehyeok/my-ws/google3/devtools/devassist"
    # Format: (workspace:dir_type)//compressed_subpath
    expected = "(my-ws:google3)//.../devassist"
    output = run_script("zsh", "zsh", path)
    assert expected in output

def test_citc_behavior_short():
    path = "/google/src/cloud/daehyeok/my-ws/google3"
    expected = "(my-ws:google3)"
    output = run_script("zsh", "zsh", path)
    assert expected in output

def test_citc_behavior_deep():
    path = "/google/src/cloud/daehyeok/my-ws/google3/java/com/google/devtools/devassist/gemini"
    expected = "(my-ws:java)//.../gemini"
    output = run_script("zsh", "zsh", path)
    assert expected in output

def test_citc_refinement_javatests():
    path = "/google/src/cloud/daehyeok/firover/google3/javatests/com/google/firover"
    # Format: (workspace:special_dir)//compressed_subpath
    expected = "(firover:javatests)//.../firover"
    output = run_script("zsh", "zsh", path)
    assert expected in output

def test_citc_refinement_blaze_bin():
    path = "/google/src/cloud/daehyeok/my-ws/google3/blaze-bin/path/to/app"
    expected = "(my-ws:blaze-bin)//.../app"
    output = run_script("zsh", "zsh", path)
    assert expected in output

def test_citc_refinement_short_label():
    path = "/google/src/cloud/daehyeok/ws/google3"
    expected = "(ws:google3)"
    output = run_script("zsh", "zsh", path)
    assert expected in output

def test_absolute_path_compression():
    path = "/usr/lib/systemd"
    expected = "/.../systemd"
    # Testing with bash too
    output = run_script("bash", "zsh", path)
    assert expected in output

def test_other_shells_compression():
    path = "/usr/local/bin"
    expected = "/.../bin"
    for shell in ["bash", "fish", "nu", "sh"]:
        output = run_script(shell, shell, path)
        assert expected in output
