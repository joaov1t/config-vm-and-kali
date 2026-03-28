@echo off
SET VM_NAME="kali-linux-2025.3-virtualbox-amd64"
SET DIR_VM="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
SET IP="add-ip-do-kali"
SET USR="add-o-seu-user"
SET RSA="add-o-caminho-da-rsa"

cls
REM Inicia a máquina virtual
echo Iniciando a maquina virtual Kali Linux...
%DIR_VM% startvm "%VM_NAME%" --type gui

# Voce pode mexer de acordo com o tempo que seu pc demora para inicar a vm
REM Aguarda 130 segundos
echo Aguardando 130 segundos para inicializacao...
timeout /t 130 /nobreak 

REM Conecta via SSH
ssh -i %RSA% %USR%@%IP%
