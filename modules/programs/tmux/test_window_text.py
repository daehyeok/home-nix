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
    expected_path = "~/projects/my-app" # Initial simple compression
    output = run_script("zsh", "zsh", path)
    assert "" in output
    assert expected_path in output
    assert "zsh" not in output # Should show path, not "zsh"

def test_new_behavior_zsh_with_shortened_path():
    # Testing more aggressive compression if implemented
    home = os.environ.get("HOME", "/Users/test")
    path = f"{home}/extremely/long/path/to/something/deep"
    # We'll refine the expected output once we decide on the compression algorithm
    output = run_script("zsh", "zsh", path)
    assert "" in output
    assert "~/" in output
