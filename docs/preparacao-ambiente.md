# Preparação do ambiente

Passo a passo usado para colocar a aplicação no ar. Ambiente de partida: Windows com SQL Server Express instalado e a VM Ubuntu `saas` (Tomcat 10 já instalado) no VMware Workstation.

## 1. Banco de dados (Windows, no SSMS)

1. Rodar [`../conf/academia.sql`](../conf/academia.sql). Ele cria o banco `Academia`, as tabelas, os dados e o login `saas`.
2. Ligar o login por usuário e senha: botão direito no servidor → **Propriedades** → **Segurança** → *Modo de Autenticação do SQL Server e do Windows* → OK → botão direito no servidor → **Reiniciar**.
3. Testar: conectar como `saas` / `saas` (Autenticação do SQL Server) e rodar `SELECT * FROM Academia.dbo.planos;`.

## 2. Liberar o SQL Server na rede (Windows)

1. **SQL Server Configuration Manager** (`SQLServerManager17.msc`) → *Configuração de Rede do SQL Server* → *Protocolos para SQLEXPRESS* → **TCP/IP** → Habilitar.
2. TCP/IP → aba **Endereços IP** → seção **IPAll**: *Portas TCP Dinâmicas* vazio e *Porta TCP* = `1433`.
3. *Serviços do SQL Server* → **SQL Server (SQLEXPRESS)** → Reiniciar.
4. Firewall, no PowerShell **como administrador**:
   ```
   New-NetFirewallRule -DisplayName "SQL Server 1433" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
   ```

## 3. Rede da VM

No VMware: **VM → Settings → Network Adapter → NAT**.

No modo *Bridged*, a VM alcançava o Windows, mas o Windows não alcançava a VM (`Connection timed out`). Em NAT, os endereços ficam fixos, em casa ou na faculdade:

| Máquina | IP |
|---|---|
| VM | `192.168.142.128` (confirmar com `hostname -I`) |
| Windows, visto pela VM | `192.168.142.1` |

Para a VM pegar o IP novo sem reiniciar: `sudo networkctl renew ens33`.

Teste, na VM, de que o banco está acessível:
```
timeout 3 bash -c '</dev/tcp/192.168.142.1/1433' && echo "PORTA ABERTA"
```

## 4. Copiar a aplicação para a VM

No `cmd` do Windows:
```
scp -r C:\caminho\academia-saas saas@192.168.142.128:/home/saas/
ssh saas@192.168.142.128
```
Na VM:
```
sudo mkdir -p /opt/tomcat10
sudo mv ~/academia-saas /opt/tomcat10/academia
sudo chmod -R a+rX /opt/tomcat10/academia
```
O `chmod` é necessário: sem ele, o Tomcat (que roda com o usuário `tomcat`) não consegue ler os arquivos e responde **HTTP 403 – Forbidden**.

## 5. Driver JDBC do SQL Server

A VM já tinha só o driver do MySQL (`mysql-connector-j`), que não serve para o SQL Server.
```
cd /tmp
wget https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/12.8.1.jre11/mssql-jdbc-12.8.1.jre11.jar
sudo cp mssql-jdbc-12.8.1.jre11.jar /usr/share/tomcat10/lib/
```

## 6. Registrar a aplicação no Tomcat

```
sudo cp /opt/tomcat10/academia/conf/academia.xml /etc/tomcat10/Catalina/localhost/
sudo systemctl restart tomcat10
systemctl status tomcat10
```
O status deve mostrar `active (running)`. O aviso amarelo *"The path attribute with value [/academia]…"* no log é inofensivo.

## 7. Testar

Abrir `http://192.168.142.128:8080/academia/`.

- **Consultar alunos**, buscar `a`: Ana Souza com 42 check-ins, Bruno Lima com 22, Carla Mendes com 6.
- **Registrar check-in**: aparece "Check-in registrado." e o registro nº 121 no topo da lista.

## Problemas encontrados

| Sintoma | Causa | Solução |
|---|---|---|
| `scp` com *Connection timed out* | VM em modo Bridged | Trocar para NAT |
| `No such file or directory` no `scp` | Faltou o `%` final em `%USERPROFILE%` | Corrigir o caminho |
| *Permission denied* no `ls` | Pasta do Tomcat é protegida | Usar `sudo` |
| HTTP 403 no navegador | Tomcat sem permissão de leitura | `sudo chmod -R a+rX /opt/tomcat10/academia` |
| `sudo` "desabilitado" no Windows | A conexão SSH caiu e o comando rodou no Windows | Reconectar com `ssh` (prompt deve ser `saas@saas:~$`) |
| Data do check-in um dia à frente | Relógio da VM em UTC | `sudo timedatectl set-timezone America/Sao_Paulo` |
