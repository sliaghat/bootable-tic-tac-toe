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
- **QEMU** or **VirtualBox** – to emulate the system

## Usage
``` bash
# assemble and link
nasm -felf32 -o boot.o boot.asm
nasm -felf32 -o kernel.o kernel.asm
ld -m elf_i386 -T linker.ld -o kernel.bin kernel.o boot.o

# check if kernel.bin valid
if grub-file --is-x86-multiboot kernel.bin; then
  echo alright
else
  trap 'echo problem with kernel.bin' ERR
fi

# create the booting directory structure
mkdir -p isodir/boot/grub
cp kernel.bin isodir/boot/kernel.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o BootableTicTacToe.iso isodir

# qemu
qemu-system-x86_64 -boot d -cdrom BootableTicTacToe.iso -m 2048

# or just use the iso to create a new vm in VirtualBox
# have fun playing tic-tac-toe!
```

## Some Images
#### Start Menu
<img width="719" height="388" alt="start-menu2" src="https://github.com/user-attachments/assets/33b0cdd0-7c89-4280-9ac3-71a7d254e2d4" />

#### Game
<img width="719" height="394" alt="game2" src="https://github.com/user-attachments/assets/33265557-b3b3-4bc5-934d-984f7d9f4f82" />

#### Draw
<img width="719" height="396" alt="exit-menu2" src="https://github.com/user-attachments/assets/e7f31898-fb71-41e0-b8ee-182f9907c364" />
