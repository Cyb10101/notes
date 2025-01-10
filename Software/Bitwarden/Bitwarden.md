# Bitwarden (Password Manager)

## Convert json to pdf

On Linux:

```bash
# Install python virtual environment
sudo apt install python3-virtualenv python3-venv python3-distutils-extra

# Generate virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install requirements
python3 -m pip install reportlab

# Convert password file
./convert-bitwarden-to-pdf.py bitwarden.json bitwarden.pdf
```

On Windows, run a PowerShell as User:

```powershell
# Open PowerShell
powershell -ExecutionPolicy RemoteSigned -NoExit

# Install python virtual environment
pip install virtualenv

# Generate virtual environment
python3 -m venv venv

# Activate virtual environment
.\venv\Scripts\Activate

# Install requirements
python3 -m pip install reportlab

# Convert password file
python3 .\convert-bitwarden-to-pdf.py bitwarden.json bitwarden.pdf
```
