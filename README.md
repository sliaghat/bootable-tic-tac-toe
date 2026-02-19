# Bootable Tic-Tac-Toe

This repository contains a **bootable** version of the classic Tic‑Tac‑Toe game, implemented entirely in x86 assembly (NASM). The game runs directly on bare metal, without the need for an operating system. The game features an **unbeatable AI** implemented via the minimax algorithm, which means that the computer will never lose (it will either win or draw).

## Features

- **Bootable** – boots using GRUB (Multiboot compliant) and runs in 32‑bit protected mode.
- **VGA Text Mode** – uses memory‑mapped I/O to display the board and messages.
- **PS/2 Keyboard Polling** – reads user input directly from the keyboard controller.
- **Unbeatable AI** – implements the minimax algorithm with depth‑based scoring to always make the best move.
- **Player Choice** – allows you to play as either **X** or **O**.
- **Rematch Option** – after a game, gives you the option to play again or quit.

## How It Works

The program is a small kernel that takes control of the screen and keyboard. It shows a colorful introduction, allows you to choose your symbol, and then enters the main game loop. The AI analyzes all possible future board states using the minimax algorithm, ensuring that the computer will never lose. All I/O operations are performed by writing directly to the VGA framebuffer at (`0xB8000`) and polling the keyboard’s data port at (`0x60`).

## Requirements

To build and test the project, you need:

- **NASM** – the Netwide Assembler
- **GNU ld** – the linker (usually part of binutils)
- **GRUB** – for creating the bootable ISO (specifically `grub-mkrescue`)
- **QEMU** – to emulate the system (optional, but recommended for testing)

Install them on a Linux system with:

```bash
sudo apt update
sudo apt install nasm binutils grub-pc-bin xorriso qemu-system-x86
