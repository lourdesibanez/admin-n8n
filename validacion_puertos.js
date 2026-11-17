// Script de análisis de puertos TCP activos contra lista blanca (Nodo Code - CU3)
const stdout = $input.first().json.stdout || "";
const lineas = stdout.split(/\r?\n/).filter(l => l.trim() !== "");

// Puertos autorizados por política de seguridad del servidor
const puertosPermitidos = [
  0, 22, 80, 135, 443, 445, 1521, 3300, 3306, 5040, 5357, 5678,
  8080, 8082, 12345, 14147, 20271, 24830, 33060, 45623,
  49664, 49665, 49666, 49667, 49668, 49670, 49677, 49678,
  53627, 53628, 58056, 58507, 60869, 62802, 63037, 63038
];

const puertosDetectados = [];
const puertosNoAutorizados = [];

for (const linea of lineas) {
  // Extraer el puerto de la columna dirección local (ej. 0.0.0.0:8080 -> 8080)
  const match = linea.match(/\s+(?:0\.0\.0\.0|127\.0\.0\.1|\[::\]|\[::1\]):(\d+)\s+/);
  if (match) {
    const puerto = parseInt(match[1], 10);
    if (!puertosDetectados.includes(puerto)) {
      puertosDetectados.push(puerto);
      if (!puertosPermitidos.includes(puerto)) {
        puertosNoAutorizados.push(puerto);
      }
    }
  }
}

return [
  {
    json: {
      fecha_auditoria: new Date().toLocaleString("es-AR"),
      hay_riesgo: puertosNoAutorizados.length > 0,
      cantidad_riesgos: puertosNoAutorizados.length,
      puertos_no_autorizados: puertosNoAutorizados.join(", ") || "Ninguno",
      puertos_totales: puertosDetectados.sort((a, b) => a - b).join(", ")
    }
  }
];