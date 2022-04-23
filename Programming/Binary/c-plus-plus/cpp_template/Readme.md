# C++ Template

This is a template for C++ development.

## Development

Install dependencies.

If you use Windows install WSL (Windows Subsystem for Linux) too.

```bash
sudo apt update
sudo apt -y install make g++

# Optional: For Windows compilation
sudo apt -y install g++-mingw-w64-x86-64
```

### Build and run

With Visual Studio Code: Ctrl + Shift + B

```bash
# Build and run application
make && ./app

# Optional: Cleanup unnecessary files
make clean

# Optional: Install app in system
make install

# Optional: Run Windows binary on Linux
wine app.exe
```
