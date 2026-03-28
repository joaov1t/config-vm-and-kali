#!/bin/bash
sudo passwd root
passwd kali
usermod -l new_user kali
mv /home/kali /home/novo_nome
usermod -d /home/new_user-m new_user
usermod -aG sudo new_user
