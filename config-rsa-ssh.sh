#!/bin/bash

echo "Gerando nova chave SSH..."

ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

echo "Adicionando chave pública ao authorized_keys..."
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

echo "[+] Chave configurada!"

echo "⚠️ Sua chave privada está em: ~/.ssh/id_rsa"
