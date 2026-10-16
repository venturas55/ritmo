# Correcciones controladas

- `app/(tabs)/settings.tsx`: elimina exportaciones internas con patrón exacto antes de vaciar SQLite; bloqueo mediante useRef evita exportar/borrar simultáneamente; botones deshabilitados durante operación. No elimina archivos de otras funciones ni copias compartidas. Error de eliminación interrumpe operación y muestra fallo.
- `app/(tabs)/settings.tsx`: corrige errata de confirmación y mensaje de fallo al abrir enlaces. Sin cambios visuales estructurales.
- `src/context.tsx`: alerta ante error de lectura inicial, antes oculto en consola. Conserva rechazo de refresh para control por llamadores.
- `app/habit/[id].tsx`: bloquea guardar/eliminar cuando no existe hábito o falla lectura. Evita comunicar guardado inexistente.

Cambios reversibles mediante revisión del diff, sin modificar esquema. No se añaden dependencias ni cambios nativos. Para distribuir estas correcciones de código hace falta un nuevo IPA mediante el proceso existente, solo cuando el propietario lo decida. No se ha generado ni enviado ninguno.

Validación: `npm run typecheck` correcto antes y después; `git diff --check` correcto. No existe script de tests ni lint en package.json. No se afirma ejecución de pruebas de interacción, SQLite nativo, notificaciones o compartir en iPhone.

Pruebas añadidas: `node --test scripts/review-settings.test.cjs`, 3/3 correctas. Ejecutan el componente transpilado con adaptadores nativos simulados: selección de archivos, exclusión mutua y fallo de borrado. Primer intento bloqueado por `spawn EPERM`; reejecución autorizada correcta. No prueban APIs nativas reales.
