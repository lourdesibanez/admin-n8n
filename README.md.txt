# Automatización de Redes, SSH y Monitoreo Preventivo con n8n y Docker

Proyecto académico desarrollado para la cátedra de Redes y Comunicaciones — Facultad de Ingeniería, Universidad Nacional de La Pampa (UNLPam).

**Integrantes:** Lourdes Ibañez, Leonela González  
**Año:** 2026

## Descripción General
Implementación de una plataforma de orquestación y monitoreo de red basada en **n8n** desplegado en contenedor **Docker** sobre un entorno anfitrión **Windows 11**, interactuando con el host mediante **OpenSSH Server (SSHv2)** y peticiones HTTP.

## Casos de Uso Implementados
1. **CU1 — Monitoreo de Disponibilidad y Failover Automático (`CU1_Failover_HTTP_Telegram.json`):** Supervisión periódica cada 15 segundos de un servicio web principal (TCP 8081) con conmutación automática hacia un servidor de respaldo (TCP 8082) y alerta inmediata por Telegram ante fallos.
2. **CU2 — Aprovisionamiento Automatizado de Red IPAM y DNS (`CU2_Aprovisionamiento_IPAM_DNS.json`):** Portal web de autoservicio que calcula la primera dirección IP libre según el rol del servidor (`WEB`, `DB`, `APP`), registra la resolución de nombres vía SSH en el host y envía un comprobante HTML por correo.
3. **CU3 — Auditoría Periódica de Puertos y Respuesta ante Anomalías (`CU3_Auditoria_Puertos_Seguridad.json`):** Escaneo autónomo cada 1 minuto de los puertos TCP activos en escucha (`netstat`), validación contra una lista blanca en JavaScript (`validacion_puertos.js`) y envío de alerta temprana por correo electrónico ante puertos no autorizados.

## Estructura del Repositorio
* `config_entorno_windows.ps1`: Comandos de PowerShell para habilitar OpenSSH Server, configurar la shell predeterminada y desplegar n8n en Docker.
* `validacion_puertos.js`: Script en JavaScript del nodo de análisis de políticas de seguridad (CU3).
* `CU1_Failover_HTTP_Telegram.json`: Flujo exportable del Caso de Uso 1 (sanitizado).
* `CU2_Aprovisionamiento_IPAM_DNS.json`: Flujo exportable del Caso de Uso 2 (sanitizado).
* `CU3_Auditoria_Puertos_Seguridad.json`: Flujo exportable del Caso de Uso 3 (sanitizado).

## Instrucciones de Importación en n8n
1. Ejecutar `config_entorno_windows.ps1` en PowerShell (como Administrador) para levantar OpenSSH y el contenedor de n8n.
2. Ingresar a `http://localhost:5678`.
3. Crear un nuevo flujo, ir al menú superior derecho (`...`) -> **Import from File** y seleccionar cada archivo `.json`.
4. Configurar las credenciales locales correspondientes (cuenta **SSH**, **SMTP** y **Telegram Bot**) en cada nodo antes de activar los flujos.