#!/bin/bash

# Atualiza o sistema
echo "🔄 Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# Instala dependências
echo "📦 Instalando dependências..."
sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

# Clona o repositório do XMRig
echo "📥 Baixando XMRig..."
git clone https://github.com/xmrig/xmrig.git

# Compila o XMRig
cd xmrig
mkdir build && cd build
echo "⚙️ Compilando XMRig..."
cmake ..
make -j$(nproc)

# Mensagem final
echo "✅ Instalação concluída! Para rodar, use:"
echo "   cd xmrig/build && ./xmrig --help"
