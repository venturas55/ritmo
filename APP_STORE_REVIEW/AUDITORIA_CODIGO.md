# Auditoría de Ritmo — 16 de octubre de 2026

## Alcance y evidencia
Revisados package.json, app.json, tsconfig.json, todas las rutas app/, módulos src/, páginas web/docs/ y dependencias declaradas. Inspección estática del checkout; no inspección del IPA presentado. La compilación y subida descritas por el propietario no se han reproducido. No se modifican workflows, firma, secretos, identificadores, dependencias, lockfile ni configuración nativa. No se accede a datos de producción.

## Funcionalidades y público
Aplicación de productividad personal en español para personas que desean mantener rutinas. Hoy permite crear hábitos, marcar cumplimiento y editar mediante flecha o pulsación larga. Editor: nombre de 1–65 caracteres, icono, color, días semanales y recordatorio opcional de 24 horas. Calendario permite corregir marcas anteriores, impide futuras. Progreso calcula porcentaje de siete días, acciones y rachas. Ajustes exporta JSON, elimina datos locales, abre privacidad y correo de soporte. SQLite almacena habits, completions y settings; claves foráneas con borrado en cascada y consultas parametrizadas. No existe importación: una exportación no permite restaurar desde la app.

## Cumplimiento observado
- Sin registro, login, logout, recuperación ni backend de cuentas. No corresponde implementar eliminación de cuenta; sí existe borrado local real.
- Nombres de hábitos son contenido privado del usuario. No hay publicación, comunidad, mensajes ni interacción entre usuarios. No se detecta necesidad funcional de denuncia/bloqueo de terceros en este modelo.
- No se detectan compras, suscripciones, productos digitales de pago, anuncios ni restauración de compras. Precio de descarga y configuración comercial requieren confirmación en App Store Connect.
- Permiso de notificaciones solicitado al guardar un hábito con recordatorio; denegación muestra aviso y conserva hábito. No se solicita ubicación, cámara, micrófono, contactos ni seguimiento en código propio.
- Avisos locales semanales mediante expo-notifications. Sin registro de token push ni servidor de notificaciones en código propio. Contenido del hábito puede aparecer en pantalla bloqueada según ajustes de iOS.
- Enlaces externos explícitos a privacidad y correo de soporte. Funciones principales usan almacenamiento local, sin fetch ni cliente HTTP en app/ o src/.
- No se demuestra ausencia de toda telemetría de SDK por revisar TypeScript. Manifest de privacidad, APIs de motivo obligatorio y tráfico del IPA requieren revisión del artefacto existente.

## Defectos confirmados del código original
1. Exportaciones ritmo-export-AAAA-MM-DD.json persistían en documentDirectory después de «Eliminar todos mis datos». Corregido para copias internas reconocidas; copias compartidas siguen siendo responsabilidad del usuario.
2. working no bloqueaba exportación/borrado: podían solaparse y recrear un archivo tras borrar. Corregido con bloqueo compartido y botones deshabilitados.
3. Carga inicial fallida solo ejecutaba console.error y mostraba estado vacío. Añadido aviso explícito, sin afirmar que se borraron datos.
4. Editor de hábito inexistente o con lectura fallida seguía habilitando guardar/eliminar. Ahora bloquea esas acciones.
5. Mensaje de enlace fallido era instrucción de desarrollo. Sustituido por orientación para usuario. Errata «puedep» corregida.

## Pendientes y riesgos, no incumplimientos demostrados del IPA
- Política y soporte locales incluyen avisos de borrador y responsable sin identidad legal; requieren información real del propietario. No se inventa identidad ni se retiran advertencias sin confirmación.
- Hoy actualiza fecha al volver a primer plano; mantener app abierta al cruzar medianoche puede conservar día anterior. Probar en dispositivo; no se amplía este parche.
- Límite de avisos pendientes de iOS y programación parcial con muchos hábitos: probar volumen, no prometer entrega garantizada.
- Fallo de inicialización SQLite carece de recuperación personalizada; no se ha provocado fallo nativo.
- Accesibilidad de iconos/días, tamaño de texto, pantallas pequeñas y teclado: validar físicamente.
- Un fallo al cancelar avisos impide borrar datos, se informa del error. Probar comportamiento real, no simular éxito.
- Exportaciones y backups del sistema pueden conservar datos fuera de SQLite; borrado lógico no prueba borrado forense ni eliminación de copias de iOS/iCloud.
- README contiene referencias antiguas a src/screens, URLs e identificador provisionales. No seguir instrucciones de cambio de identificador ni de compilación para esta auditoría.

## Fuentes oficiales consultadas
- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/): 2.1 integridad y acceso, 2.3 metadatos, 1.2 contenido público, 3.1 pagos, 5.1 privacidad.
- [Account deletion](https://developer.apple.com/support/offering-account-deletion-in-your-app/): aplicable cuando se crean cuentas.
- [App Review](https://developer.apple.com/app-store/review/): recursos para revisión y notas.
Estas fuentes orientan la revisión; no garantizan aprobación ni sustituyen validación jurídica.
