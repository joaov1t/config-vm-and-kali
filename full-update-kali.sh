#!/bin/bash

# Verifica se o usuário é root
if [[ $EUID -ne 0 ]]; then
   echo "Este script precisa ser executado como root. Use: sudo $0" 
   exit 1
fi

echo "=== Iniciando atualização completa do sistema ==="

# Função de loading para os titulos
loading() {
  msg="$1"
  while true; do
    for i in "." ".." "..."; do
      echo -ne "\r$msg$i "
      sleep 0.4
    done
  done
}

run_loading() {
  msg="$1"
  shift

  loading "$msg" &
  pid=$!

  "$@" > /dev/null 2>&1

  kill $pid
  wait $pid 2>/dev/null

  echo -e "\r$msg... ✔"
}

# Variáveis
c="clear"
i="sudo apt-get install -y"
p="sudo pip3 install"
b="--break-system-packages"
w="sudo wget"
co="sudo cp -r"
rmf="sudo rm -rf"
token="Coloque o token aqui"
user="kali"

# Customizando terminalz
sudo git clone https://github.com/cesarbtakeda/MyBash-Zshrc.git && cd MyBash-Zshrc
sudo cp -r zshrc.sh ~/.zshrc && cp -r zshrc.sh /home/$user/.zshrc

# Muda a source list
grep -q "deb-src http://http.kali.org/kali" /etc/apt/sources.list || \
echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list

# Configura o proxychains4
echo "socks5  127.0.0.1 9050" >> /etc/proxychains4.conf

run_loading "[*Atualizando arquivos*" sudo apt-get update
run_loading "[*Atualizando sistema*" sudo apt-get upgrade -y
$c

# Instalação do Ngrok
run_loading "🌐 Instalando Ngrok" bash -c '
curl -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" | \
sudo tee /etc/apt/sources.list.d/ngrok.list >/dev/null && \
sudo apt update -y && sudo apt install -y ngrok
'

echo "✔ Ngrok instalado"

# Token
read -s -p "Token do ngrok: " token
echo ""
ngrok config add-authtoken "$token"
echo "✔ Token configurado"

# Instalação de pacotes básicos
run_loading "[*Instalando pacotes básicos*" bash -c '
packages=(python3-pip php-curl python3 wget apache2)
for pkg in "${packages[@]}"; do
  sudo apt-get install -y "$pkg"
done
'

# Cloudflared
run_loading "[*Baixando Cloudflared*" bash -c '
wget https://github.com/cloudflare/cloudflared/releases/download/2025.1.0/cloudflared-fips-linux-amd64 -O cloudflare && \
chmod +x cloudflare && \
sudo mv cloudflare /usr/local/bin/
'

echo "[*Cloudflared baixado e instalado com sucesso*]"

# ferramentas pessoais
run_loading "[*Baixando ferramentas pessoais*" bash -c '
sudo apt-get install -y gccgo-go golang-go apksigner apktool zipalign php-curl tor seclists && \
pipx install uro && sudo pipx install uro
'
$c

# bug bounty
run_loading "[*Baixando ferramentas bug bounty*" bash -c '
git clone https://github.com/s0md3v/XSStrike.git && cd XSStrike && \
sudo chmod +x * && sudo mv * /usr/loca/bin/ && \
sudo go install github.com/tomnomnom/waybackurls@latest && \
sudo go install github.com/tomnomnom/gf@latest && \
sudo CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest && \
sudo go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
'
$c

# phishing tools
run_loading "[*Baixando ferramentas de phishing*" bash -c '
git clone https://gitlab.com/KasRoudra/MaxPhisher && \
git clone https://gitlab.com/KasRoudra/CamHacker && \
git clone https://github.com/Lucksi/Mr.Holmes && \
git clone https://github.com/cesarbtakeda/H00ks_T0x1na.git && \
cd H00ks_T0x1na/API-BEEF && \
git clone https://github.com/beefproject/beef.git && cd beef && \
sudo chmod +x * && sudo ./install && \
sudo bundle install && sudo chmod +x * && \
sudo cp -r ../config.yaml config.yaml
'

# limpeza
run_loading "[*Limpando sistema*" sudo apt-get install kali-linux-everything -y
run_loading "[*Removendo pacotes desnecessários*" sudo apt-get autoremove -y
$c

run_loading "[*Atualizando ferramentas*" bash -c '
sudo subfinder -up && sudo wpscan --update && sudo nuclei -ut
'
$c

# serviços
run_loading "[*Iniciando serviços*" bash -c '
sudo systemctl start ssh && sudo systemctl enable ssh.service && \
sudo systemctl start tor && sudo systemctl enable tor.service && \
sudo systemctl start postgresql && sudo systemctl enable postgresql.service && \
sudo systemctl start apache2 && sudo systemctl enable apache2.service && \
sudo msfdb init && sudo msfdb start
'

echo "[*A atualização foi concluída com sucesso*]"
