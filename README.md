# Dotfiles
This repository is collections of dotfiles I personally use.

The directory structure any scaffolding for many of my dotfiles were inspired by Luke Smith: https://github.com/LukeSmithxyz/voidrice .
You should probably check out his dotfiles and his youtube channel.

Currently I am using Artix(btw) and there is a bootstrap script for it if you want to try out my config.

The dotfiles and programs here are centered around i3 and vim motions.

## Vscode bindings
if you see *motion*, that probably h,j,k or l
if action is connected to terminal or editor, they probably must be active

### **editor**
commands to navigate in text editor
Binding | Action
------- | ------
**alt + [0..9]** | focus on editor tab 0..9
**ctrl + enter** | split, open another editor
**ctrl + q** | close active editor tab / kill active terminal
**ctrl + shift + q** | close all editors
**alt + h / l** | focus next / previous editor group
**alt + shift + h / l** | move editor to next / previous group
**alt + j / k** | go up/down in autocomplete thingy
**ctrl + f** | go to definition
**ctrl + shift + f** | go back
**ctrl + /** | global search ( **/** is regular search)
**alt + /** | line comment (since **ctrl + /** is taken)

### **terminal**
actions related to terminal
Binding | Action
------- | ------
**ctrl + shift + space** | toggle terminal 
**ctrl + [1..5]** | focus on terminal 1..5
**ctrl + enter** | split, open another terminal
**ctrl + q** | kill active terminal
**ctrl + shift + motion** | resize terminal

### **files explorer**
actions related to navigating in files explorer
all of these are mapped to alt because my pinky hurts, you'll thank me later
Binding | Action
------- | ------
**alt + e** | toggle between files explorer and editor
**alt + f** | create file
**alt + d** | create directory
**alt + shift + d** | delete file
**alt + j / k** | go up/down in files explorer
**alt + y** | copy file
**alt + p** | paste file

### **breadcrumbs**
use **alt+shift+e** to enter breadcrumbs mode and **alt + motion** to navigate