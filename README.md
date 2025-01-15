# Configuração de Ambiente e Projeto

## Tecnologias Utilizadas

- **WSL (Windows Subsystem for Linux)**
- **Ubuntu**
- **AWS EC2**
- **Nginx**
- **Shell Script**
- **Crontab**

## Configuração do Ambiente

### WSL e Ubuntu

Para o projeto, utilizaremos a distribuição Ubuntu no Windows através do WSL. O processo de instalação e configuração é simples:

1. Abra o PowerShell como administrador;
2. Execute o comando:
   ```bash
   wsl --install
   ```
3. Instale o Ubuntu com:
   ```bash
   wsl --install -d Ubuntu
   ```
4. Após a instalação, reinicie a máquina.

Após reiniciar, inicialize o Ubuntu no menu do Windows. Configure-o definindo o nome de usuário e senha, e aguarde a inicialização.

---

### Instância AWS

Para colocar em prática os conhecimentos adquiridos, criaremos uma instância EC2 e nos conectaremos a ela via SSH.

[Guia oficial da AWS para criar uma instância EC2](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/tutorial-launch-my-first-ec2-instance.html)

1. Escolha uma AMI (Amazon Machine Image). Neste projeto, utilizamos o Ubuntu;
2. Selecione o tipo de instância (recomendado: `t2.micro`, elegível no Free Tier);
3. Crie ou selecione um par de chaves;
4. Configure os detalhes de rede conforme necessário;
5. Configure o Security Group, permitindo conexão SSH com seu IP, e ajuste HTTP/HTTPS se necessário.

---

### Conectando via SSH

1. Navegue até o diretório onde está sua chave privada.
2. Aplique permissões de segurança:
   ```bash
   chmod 400 chave1.pem
   ```
3. Na interface AWS, copie o comando de conexão SSH e execute-o no terminal.
4. Aceite a conexão digitando `yes`.
5. Verifique se a instância possui acesso à internet:
   ```bash
   ping 8.8.8.8
   ```

---

## Configuração do Servidor

### Nginx

Instale o Nginx na máquina seguindo os passos:

1. Atualize os pacotes e instale o Nginx:
   ```bash
   sudo apt update && sudo apt upgrade
   sudo apt install nginx
   ```
2. Ative e inicie o serviço:
   ```bash
   sudo systemctl enable nginx
   sudo systemctl start nginx
   ```
3. Verifique o status:
   ```bash
   systemctl status nginx
   ```
4. Obtenha o IP público da instância:
   ```bash
   curl -4 icanhazip.com
   ```
5. Acesse o IP no navegador para visualizar a página padrão do Nginx.

**Perfis do UFW (Firewall):**

- **Nginx Full**: Porta 80 (HTTP) e 443 (HTTPS);
- **Nginx HTTP**: Apenas porta 80;
- **Nginx HTTPS**: Apenas porta 443.

**Comandos úteis:**

```bash
sudo systemctl stop nginx
sudo systemctl start nginx
sudo systemctl restart nginx
sudo systemctl reload nginx
sudo systemctl disable nginx
sudo systemctl enable nginx
```

---

## Automação e Monitoramento

### Shell Script

Criamos um script para verificar o status do servidor e registrar logs.

**Caminho do script:** `/usr/local/bin/nginx-server/check.sh`

**Caminho dos logs:** `/var/log/nginx-server/`

**Conteúdo do script:**

```bash
#!/bin/bash

datetime=$(date "+%d-%m-%Y %H:%M:%S")
red='\033[0;31m'
green='\033[0;32m'
nocolor='\033[0m'
service="nginx"

if [ "$(systemctl is-active $service)" = "active" ]; then
  echo -e "$datetime ${green}[OK] O servidor $service está online!${nocolor}" >> /var/log/nginx-server/checkOn.log
else
  echo -e "$datetime ${red}[ERROR] O servidor $service está offline!${nocolor}" >> /var/log/nginx-server/checkOff.log
fi
```

**Dê permissão de execução ao script:**

```bash
chmod +x /usr/local/bin/nginx-server/check.sh
```

---

### Crontab

Para automatizar o script, instalamos e configuramos o `cron`.

1. Instale o cron:
   ```bash
   sudo apt update && sudo apt upgrade
   sudo apt install cron
   ```
2. Edite o arquivo `/etc/crontab` e adicione:
   ```bash
   */5 * * * * root /usr/local/bin/nginx-server/check.sh
   ```
   Esse comando executa o script a cada 5 minutos.
3. Verifique os logs em tempo real:
   ```bash
   tail -f /var/log/nginx-server/checkOn.log
   ```

---

## Referências

- [Tutorial AWS EC2](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/tutorial-launch-my-first-ec2-instance.html)
- [Instalação do Nginx](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04-pt)
- [Guia de Crontab](https://irias.com.br/blog/crontab-guia-pratico-agendamento-de-tarefas-no-linux/)
