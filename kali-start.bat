@echo off
SET VM_NAME="kali-linux-2025.3-virtualbox-amd64"
SET DIR_VM="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
SET IP="Defina-seu-IP"
SET USR="Defina-o-seu-user"
SET RSA="Defina-o-caminho-da-rsa"

cls
REM Inicia a máquina virtual
echo Iniciando a maquina virtual Kali Linux...
%DIR_VM% startvm "%VM_NAME%" --type gui

REM Aguarda 60 segundos
echo Aguardando 60 segundos para inicializacao...
timeout /t 60 /nobreak 

REM Conecta via SSH
ssh -i %RSA% %USR%@%IP%
