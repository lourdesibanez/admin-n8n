# ==============================================================================
# Script de Configuración del Entorno Host (Windows 11 + OpenSSH + Docker n8n)
# ==============================================================================

# 1. Instalar e iniciar OpenSSH Server en Windows 11
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Set-Service -Name sshd -StartupType 'Automatic'
Start-Service sshd

# 2. Configurar PowerShell como shell predeterminada para sesiones SSH
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell `
  -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" `
  -PropertyType String -Force

# 3. Crear usuario local dedicado para auditoría SSH (reemplazar <PASSWORD_SEGURA> antes de ejecutar)
# New-LocalUser -Name "n8nuser" -Password (ConvertTo-SecureString "<PASSWORD_SEGURA>" -AsPlainText -Force)
New-Item -ItemType Directory -Force -Path "C:\Users\n8nuser"

# 4. Habilitar regla de firewall para SSH en perfiles Privado y Dominio
New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -DisplayName "OpenSSH Server (sshd)" `
  -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 -Profile Private,Domain

Restart-Service sshd

# 5. Desplegar contenedor Docker de n8n vinculado exclusivamente a localhost (127.0.0.1)
docker run -d --name n8n-monitor `
  --restart unless-stopped `
  -p 127.0.0.1:5678:5678 `
  -e GENERIC_TIMEZONE="America/Argentina/Buenos_Aires" `
  -v n8n_data:/home/node/.n8n `
  n8nio/n8n:latest