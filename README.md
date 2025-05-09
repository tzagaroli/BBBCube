# C++ Application Template for BeagleBone & Desktop

This project template provides a structured starting point for building and running C++ applications on both **your local machine** and a **remote BeagleBone Black (BBB)**.

It supports development in **Visual Studio Code** as well as from the **terminal**, with an automated build and task system using `makefile` and `manage_cube.sh`.

---

## 📁 Project Structure

```
project/
├── include/ # Header files for application logic
├── src/ # Source files (must match include declarations)
├── lib/ # Local libraries (grouped by domain)
├── .vscode/ # VS Code tasks, debugger configs, settings
├── makefile # Central build file (local or cross)
├── manage_cube.sh # Helper script for building/deploying from terminal
```

You **must follow this structure** for the build system and tasks to work properly.

---

## 🧰 Getting Started (VS Code)

If your machine comes with any of these pre-installed skip the installation (the emsys VM can skip 2.)

### 1. Install VS Code

- Download from: https://code.visualstudio.com/ or through packet manager

### 2. Install Required Tools

Install a C++ compiler and Make:

```bash
sudo apt update
sudo apt install make
sudo apt install g++
```

#### For native/local development:

```bash
sudo apt update
sudo apt install build-essential gdb
```
#### For BBB developement:

```bash
sudo apt install g++-arm-linux-gnueabihf
```

### 3. Install Required Extensions

Search and install the following extensions in VS Code:

- `C/C++` (by Microsoft) – for IntelliSense and debugging  
- `Makefile Tools` – for make-based builds  
- `Task Runner` by `Sana Ajani` – to execute tasks from the left sidebar with one click

### 4. Open the Project Folder

Just open the root of the repository with VS Code.

### 5. Use Predefined Tasks

- Open the **Task Runner** sidebar (usually a new icon appears on the left)
- Click to run:
    - `build native`
    - `run on native`
    - `build for BBB`
    - `run on BBB`
- Debugger are setup:
    - `Debug Local`
    - `Debug on BBB`

All configurations (compilers, debuggers, paths) are preconfigured in `.vscode/tasks.json` and `.vscode/launch.json`.

### 6. Set up SSH Key Authentication for Root Login on BeagleBone Black (BBB)

If you start out fresh, it’s a good idea to configure SSH key authentication to avoid having to enter the root password every time you connect to the BeagleBone Black (BBB).

To do this, follow these steps:

1. **Ensure you have access to the BBB**: Make sure you can still log in to your BeagleBone Black using the root password. If you don't have access, make sure the BBB is properly connected and accessible over the network.

2. **Run the SSH key setup script**: Use the task `copy ssh-key to BBB` and enter the root password to copy your PC's ssh-Key to the BeagleBone Black,  allowing for password-less login in the future.
The `manage_cube.sh` script also contains a helper function. To copy your SSH key to the BBB, run the following command:

```bash
./manage_cube.sh --copy-sshkey
```
---

## 💻 Terminal-Only Usage (no VS Code)

(warning: debugger is setup in VS Code)
You can also use the project entirely from the terminal and any text editor:

Check `./manage_cube -h` for more information