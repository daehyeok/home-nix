import subprocess
import os
import pytest
import shutil

# Path to the wrapper script we will create
WRAPPER_PATH = os.path.join(os.path.dirname(__file__), "cat_wrapper.sh")

def run_wrapper(args, env=None):
    """Runs the wrapper script with given args and environment."""
    current_env = os.environ.copy()
    if env:
        current_env.update(env)
    
    # We use bash to run the script
    result = subprocess.run(
        ["bash", WRAPPER_PATH] + args,
        env=current_env,
        capture_output=True,
        text=True
    )
    return result

@pytest.fixture(autouse=True)
def check_dependencies():
    """Ensure cat and bat are available for testing."""
    if not shutil.which("cat"):
        pytest.skip("cat command not found")
    # We don't skip if bat is missing, as the wrapper might use absolute paths
    # or we might want to see the error.

def test_cat_when_gemini_cli_is_1():
    """Test that original cat is used when GEMINI_CLI=1."""
    # Create a dummy file
    test_file = "test_gemini.txt"
    content = "Hello Gemini"
    with open(test_file, "w") as f:
        f.write(content)
    
    try:
        # Run with GEMINI_CLI=1
        # We expect it to call 'cat', which just prints the content
        response = run_wrapper([test_file], env={"GEMINI_CLI": "1"})
        assert response.returncode == 0
        assert response.stdout.strip() == content
        # original cat doesn't add decorations like bat does by default
        assert "───" not in response.stdout 
    finally:
        if os.path.exists(test_file):
            os.remove(test_file)

def test_bat_when_gemini_cli_is_not_1():
    """Test that bat is used when GEMINI_CLI is not 1."""
    test_file = "test_bat.txt"
    content = "Hello Bat"
    with open(test_file, "w") as f:
        f.write(content)
    
    try:
        # Run without GEMINI_CLI=1
        # We expect it to call 'bat'. 
        response = run_wrapper([test_file], env={"GEMINI_CLI": "0"})
        
        # If bat is used, it might have decorations or at least work
        assert response.returncode == 0
        assert content in response.stdout
    finally:
        if os.path.exists(test_file):
            os.remove(test_file)

def test_args_passing():
    """Test that arguments are passed correctly to the underlying command."""
    test_file = "test_args.txt"
    content = "Line 1\nLine 2"
    with open(test_file, "w") as f:
        f.write(content)
    
    try:
        # Test with -n (number lines) which is supported by both cat and bat
        response = run_wrapper(["-n", test_file], env={"GEMINI_CLI": "1"})
        assert response.returncode == 0
        assert "1" in response.stdout
        assert "Line 1" in response.stdout
    finally:
        if os.path.exists(test_file):
            os.remove(test_file)
