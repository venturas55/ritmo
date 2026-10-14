# RITMO — iOS/TestFlight desde Windows con GitHub Actions

## Qué incluye
Workflow manual con runner macOS (`macos-26`), Node 22, `npm ci`, verificación de TypeScript, `expo prebuild`, CocoaPods, firma **manual de distribución App Store**, `xcodebuild archive/exportArchive`, artefacto `.ipa` y subida opcional a TestFlight. **No utiliza EAS Build ni EAS Cloud.**

## Requisitos antes del primer build

1. Proyecto RITMO funcionando con Expo SDK 57, `npm run typecheck` correcto y **`package-lock.json` actualizado y guardado**. Este paquete es un *complemento*: NO reemplaza tu `package.json`, `app.json` ni código. La copia antigua del ZIP de RITMO era SDK 54; usa el proyecto ya migrado en tu PC.
2. Una cuenta de [GitHub](https://github.com) y repositorio **privado** con el proyecto. Git for Windows instalado.
3. Cuenta Apple Developer con permiso para certificados y App Store Connect; ficha de aplicación en App Store Connect creada con su Bundle ID definitivo.
4. Certificado **Apple Distribution** con **clave privada** exportado como `.p12` y contraseña. Un `.cer` descargado aislado **no basta** para firmar: se necesita la clave privada correspondiente.
5. Perfil de aprovisionamiento de distribución **App Store Connect** (`.mobileprovision`) ligado al Bundle ID y al certificado. No sirve un perfil Development/Ad Hoc.
6. Clave **Team App Store Connect API**, descargada como `AuthKey_XXXXXXXXXX.p8`, con Key ID e Issuer ID. Apple solo permite descargar la clave privada cuando se crea. Usa permisos mínimos necesarios (por ejemplo App Manager). Esta clave sirve para **subir**, no sustituye el `.p12` ni el perfil de firma.

## 1. Preparar la configuración Expo

En `app.json`, comprueba que `expo.ios.bundleIdentifier` sea tu identificador **definitivo**. Sustituye `com.tumarca.ritmo`. Si aún existe `expo.splash`, elimínalo: Expo SDK 57 exige configurar splash mediante `expo-splash-screen`.

Prueba en Windows:

```powershell
npm install
npx expo install --check
npx expo-doctor
npm run typecheck
```

No ejecutes `npm audit fix --force` para corregir incompatibilidades. No subas `node_modules`.

## 2. Copiar archivos del ZIP

Copia en la raíz de tu proyecto las carpetas `.github/` y `scripts/`, y añade las líneas de `.gitignore.extra` a tu `.gitignore` existente. No reemplaces otras carpetas. **No subas el `.p12`, la clave `.p8`, ni el `.mobileprovision` al repositorio.**

## 3. Crear certificado y perfil Apple

- En [Apple Developer — Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/certificates/list) registra el App ID explícito, por ejemplo `com.tuempresa.ritmo`.
- Crea (o utiliza) un certificado **Apple Distribution** y un perfil **App Store Connect** con ese App ID.
- Como solo tienes Windows, generar la clave privada y obtener un `.p12` requiere un procedimiento de CSR y empaquetado que conserve la clave privada. Si ya tienes un `.p12` de distribución válido de otros proyectos, puedes reutilizarlo si corresponde al mismo equipo y el perfil incluye ese certificado. Si nunca has creado uno, consulta el documento `CERTIFICADO_DESDE_WINDOWS.md` incluido en el ZIP.
- Registra el Bundle ID y crea la ficha de RITMO en [App Store Connect](https://appstoreconnect.apple.com). La ficha debe existir antes de subir la compilación.

## 4. Añadir Variables y Secrets a GitHub

En el repositorio: **Settings → Secrets and variables → Actions**.

**Variables** (pestaña Variables):

| Nombre | Contenido |
|---|---|
| `APPLE_TEAM_ID` | Team ID de Apple Developer (10 caracteres aprox.) |
| `APPLE_BUNDLE_ID` | Bundle ID exacto, por ejemplo `com.tuempresa.ritmo` |
| `ASC_KEY_ID` | Key ID de la API de App Store Connect |
| `ASC_ISSUER_ID` | Issuer ID de la API de App Store Connect |

**Secrets** (pestaña Secrets):

| Nombre | Contenido |
|---|---|
| `IOS_P12_BASE64` | Contenido `.p12` codificado Base64, en **una sola línea** |
| `IOS_P12_PASSWORD` | Contraseña del `.p12` |
| `IOS_PROFILE_BASE64` | Contenido del `.mobileprovision` en Base64, en una sola línea |
| `ASC_PRIVATE_KEY` | Contenido completo de `AuthKey_....p8`, incluidas líneas BEGIN/END |
| `KEYCHAIN_PASSWORD` | Opcional: contraseña aleatoria fuerte para llavero temporal |

Generar Base64 en PowerShell sin escribirlo en un repositorio:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes('C:\ruta\distribution.p12')) | Set-Clipboard
# Pega la cadena en IOS_P12_BASE64 y luego:
[Convert]::ToBase64String([IO.File]::ReadAllBytes('C:\ruta\Ritmo_AppStore.mobileprovision')) | Set-Clipboard
# Pega en IOS_PROFILE_BASE64.
```

Para la `.p8`, abre el archivo de texto y copia todo su contenido al secret `ASC_PRIVATE_KEY` (no Base64).

## 5. Subir repositorio (Windows)

```powershell
git init
git add .
git commit -m "RITMO Expo 57 with iOS GitHub Actions CI"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/TU-REPOSITORIO.git
git push -u origin main
```

Si el repositorio ya estaba iniciado, omite `git init`, `remote add` y la creación de rama. Comprueba `git status` antes de hacer push.

## 6. Ejecutar workflow

GitHub → repositorio → **Actions** → **RITMO iOS — build and TestFlight** → **Run workflow**.

- Primera ejecución: `upload_testflight` **desmarcado**. Descarga el artifact `ritmo-ios-ipa-N` y comprueba que el IPA se generó correctamente.
- Segunda ejecución: `upload_testflight` **marcado**. El workflow vuelve a compilar y después envía el IPA a App Store Connect/TestFlight.
- En App Store Connect → TestFlight, espera a que Apple procese la compilación. Puede solicitar información de cumplimiento de exportación y requisitos de beta testing. Para testadores externos puede ser necesaria revisión beta.

El número de build usa `github.run_number`, de modo que las sucesivas ejecuciones del **mismo workflow** suben de número automáticamente. No se garantiza la unicidad si previamente subiste builds con numeraciones superiores desde otros sistemas: en ese caso ajusta el número/estrategia en `scripts/ios_build_archive.sh`.

## Problemas frecuentes

- `npm ci` falla: no has subido `package-lock.json` sincronizado con Expo SDK 57. Rehaz `npm install` en Windows y vuelve a subir el lockfile.
- `Bundle ID mismatch`: `APPLE_BUNDLE_ID` no coincide exactamente con `expo.ios.bundleIdentifier`.
- `No valid signing identities`: `.p12` sin clave privada, contraseña errónea, certificado caducado o no es Apple Distribution.
- `No profiles`: el `.mobileprovision` es de otro equipo/App ID, está caducado, o no incluye el certificado.
- `No shared Xcode scheme`: revisar la salida de `expo prebuild` y la ruta de esquemas; puede requerir definir esquema manual.
- `pod install` falla: revisar compatibilidad entre Expo 57, CocoaPods y la versión de Xcode del runner.
- `method app-store-connect unsupported`: consultar `xcodebuild -help` en el runner para escoger el valor de método aceptado por esa versión de Xcode.
- TestFlight no aparece inmediatamente: Apple necesita procesar la compilación y puede solicitar aceptar acuerdos o responder requisitos en App Store Connect.

## Seguridad y costes

GitHub Actions tiene cuotas distintas para repositorios privados y públicos; **runner macOS consume minutos facturables** según el plan. Controla `Settings → Billing → Actions` y evita builds en cada `push` (este workflow solo se ejecuta manualmente). Los artifacts contienen el IPA firmado: acceso limitado al repositorio. Revoca las credenciales de Apple si se filtran.

Este workflow no se ha ejecutado en una cuenta Apple real; proporciona la automatización y validaciones configuradas, pero la primera compilación puede requerir ajustes específicos de certificado, capabilities, nombre de scheme o Xcode/Expo.
