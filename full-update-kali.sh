#!/bin/bash

# Verifica se o usuário é root
if [[ $EUID -ne 0 ]]; then
   echo "Este script precisa ser executado como root. Use: sudo $0" 
   exit 1
fi

echo "=== Iniciando atualização completa do sistema ==="

# Variáveis
c="clear"
p="sudo pip3 install"
b="--break-system-packages"
w="sudo wget"
co="sudo cp -r"
rmf="sudo rm -rf"
user="kali"

# Customizando terminal
git clone https://github.com/joaov1t/mybash-interface && cd mybash-interface
sudo cp -r mybash-interface.sh ~/.zshrc && cp -r mybash-interface.sh /home/$user/.zshrc

# Muda a source list
grep -q "deb-src http://http.kali.org/kali" /etc/apt/sources.list || \
echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list

# Configura o proxychains4
echo "socks5  127.0.0.1 9050" >> /etc/proxychains4.conf

echo "[*Atualizando arquivos*" sudo apt-get update -y
echo "[*Atualizando sistema*" sudo apt-get upgrade -y
$c

# Instalação do Ngrok
echo "🌐 Instalando Ngrok" 
curl -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" | \
sudo tee /etc/apt/sources.list.d/ngrok.list >/dev/null && \
sudo $i ngrok


echo "✔ Ngrok instalado"

# Token
read -s -p "Token do ngrok: " token
echo ""
ngrok config add-authtoken "$token"
echo "✔ Token configurado"


# Instalação de pacotes básicos
echo "[*Instalando pacotes básicos*]" 
sudo apt-get install -y python3-pip
sudo apt-get install -y php-curl
sudo apt-get install -y python2
sudo apt-get install -y python3 
sudo apt-get install -y wget 
sudo apt-get install -yapache2



# Cloudflared
echo "[*Baixando Cloudflared*]" 
wget https://github.com/cloudflare/cloudflared/releases/download/2025.1.0/cloudflared-fips-linux-amd64 -O cloudflare
chmod +x cloudflare
sudo mv cloudflare /usr/local/bin/
echo "[*Cloudflared baixado e instalado com sucesso*]"

# ferramentas pessoais
echo "[*Baixando ferramentas pessoais*]"  
sudo go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
sudo apt-get install -y openvpn
&& sudo apt-get install -y golang-go
&& sudo apt-get install -y apktool
sudo apt-get install -y zipalign && sudo apt-get install -y php-curl
sudo apt-get install -y tor && sudo apt-get install -y seclists
pipx install uro && sudo pipx install uro
$c

# bug bounty
echo "[*Baixando ferramentas bug bounty*]"  
git clone https://github.com/cesarbtakeda/H00ks_T0x1na.git && cd H00ks_T0x1na/API-BEEF
git clone https://github.com/beefproject/beef.git && cd beef
sudo chmod 777 * && sudo ./install
sudo bundle install -y && sudo chmod 777 *
$co ../config.yaml config.yaml

# phishing tools
echo "[*Baixando ferramentas de phishing*]" 
git clone https://gitlab.com/KasRoudra/MaxPhisher && \
git clone https://gitlab.com/KasRoudra/CamHacker && \
git clone https://github.com/Lucksi/Mr.Holmes && \
git clone https://github.com/cesarbtakeda/H00ks_T0x1na.git

echo "[*Baixando Beef*]" 
git clone https://github.com/beefproject/beef.git && cd beef && \
sudo chmod +x * && sudo ./install && \
sudo bundle install && sudo chmod +x * && \
sudo cp -r ../config.yaml config.yaml

# configurando pastas das ferramentas baixadas
sudo mv ~/go/bin/httpx ~/go/bin/httpx-pd
$co ~/go/bin/*  /usr/local/bin/

# limpeza
echo "[*Limpando sistema*]" sudo apt-get install kali-linux-everything -y
echo "[*Removendo pacotes desnecessários*]" sudo apt-get autoremove -y
$c

echo "[*Atualizando ferramentas*" 
sudo subfinder -up && sudo wpscan --update && sudo nuclei -ut

$c

# serviços
echo "[*Iniciando serviços*]" 
sudo systemctl start ssh && sudo systemctl enable ssh.service && \
sudo systemctl start tor && sudo systemctl enable tor.service && \
sudo systemctl start postgresql && sudo systemctl enable postgresql.service && \
sudo systemctl start apache2 && sudo systemctl enable apache2.service && \
sudo msfdb init && sudo msfdb start


echo "[*A atualização foi concluída com sucesso*]"
