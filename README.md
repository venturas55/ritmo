# RITMO — Gestor de hábitos (Expo + SQLite)

Aplicación móvil **offline-first** desarrollada con React Native, Expo Router, TypeScript y SQLite. Interfaz en español, calendario, estadísticas, rachas, avisos semanales locales, exportación JSON y borrado completo de datos.

## Requisitos

- Node.js 20.19+ (recomendado Node 22 LTS), npm, iPhone o Android con Expo Go compatible con SDK 54.
- Para publicar en iOS: cuenta de pago Apple Developer y cuenta Expo/EAS.
- El paquete **no incluye `node_modules`**: se instalan al ejecutar npm install.

## Arranque local (Windows, macOS, Linux)

```bash
cd ritmo-project
npm install
npx expo install --check
npm run start
```

Abre Expo Go en tu iPhone/Android y escanea el QR, o ejecuta un simulador iOS con Mac/Xcode o Android con Android Studio. En redes restrictivas: `npx expo start --tunnel`.

> Se ha preparado el proyecto para Expo SDK 54 (línea estable fijada en el package.json). Si npm informa de versiones incompatibles, ejecuta `npx expo install --fix` y, tras ello, `npm run typecheck`. Se recomienda conservar el package-lock.json resultante.

## Uso

1. Pulsa **+** y crea un hábito.
2. Escoge los días de la semana, color, icono y recordatorio opcional.
3. Toca un hábito en «Hoy» para marcarlo; toca su flecha para editarlo.
4. Revisa las fechas pasadas en «Calendario» y el resumen semanal en «Progreso».
5. En «Ajustes», exporta un JSON con tus datos o elimínalos definitivamente.

## Arquitectura

- `app/`: rutas y navegación Expo Router.
- `src/db.ts`: tablas SQLite (habits / completions / settings), migración inicial y consultas parametrizadas.
- `src/context.tsx`: carga y refresco centralizados; `useData()` para pantallas.
- `src/date.ts`: días locales, frecuencia, porcentajes y rachas.
- `src/notifications.ts`: avisos locales semanales; se sustituyen al editar o eliminar hábitos.
- `src/theme.ts` y `src/ui.tsx`: paleta y componentes reutilizables.
- `assets/`: icono y splash provisionales originales.

## Avisos y límites

- RITMO funciona de manera **local**: reinstalar la app o borrar su almacenamiento puede eliminar los datos. Exporta antes de hacerlo.
- Los recordatorios son locales, no push remoto. Los permisos se solicitan cuando se habilita el primer aviso.
- La exportación JSON es una **copia de seguridad de salida**; la importación aún no está implementada.
- En `src/screens` no hay backend ni Analytics ni acceso a Internet. Los enlaces de privacidad y soporte (`app/(tabs)/settings.tsx`) son **marcadores de posición** que deben sustituirse por URLs propias válidas antes de publicar.
- El `bundleIdentifier` en `app.json` es un ejemplo y debe cambiarse antes de crear la app en App Store Connect.
- No se garantiza que Apple apruebe una app sin efectuar pruebas reales y completar la ficha pública.

## Comprobación

```bash
npm run typecheck
npx expo-doctor
```

Pruebas manuales: crear, editar y eliminar hábitos; seleccionar lunes/viernes; activar y desactivar recordatorios; cerrar y abrir la app; cambio de día; marcas pasadas; meses de 28/29/30/31 días; exportar y borrar datos.

## Publicación

```bash
npm install -g eas-cli
eas login
eas build:configure
eas build --platform ios --profile production
eas submit --platform ios --latest
```

Después, en App Store Connect: completar política de privacidad, datos de la app, edad, URL de soporte, capturas reales, icono, derechos y descripción; realizar TestFlight y enviar a revisión. `eas submit` no publica automáticamente.

## Mejoras posteriores

Importación de backup, widgets, rachas históricas, accesibilidad reforzada, pruebas automatizadas en dispositivos y sincronización opcional entre equipos.
