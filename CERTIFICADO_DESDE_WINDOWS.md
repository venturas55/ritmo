# Obtener .p12 Apple Distribution solo con Windows

La firma iOS exige un certificado Apple Distribution **junto con su clave privada**. El certificado `.cer` descargado de Apple, por sí solo, no permite firmar. La API key `.p8` de App Store Connect NO es la clave privada de firma.

Si **ya tienes un `.p12` de distribución válido** de otro proyecto del mismo Apple Developer Team, puedes reutilizarlo y crear un perfil específico para el Bundle ID de RITMO. Esta es la opción más sencilla.

## Crear clave y CSR usando OpenSSL en Windows

Usa Git Bash con OpenSSL o un OpenSSL confiable instalado en Windows. Guarda los archivos en una carpeta **fuera de Git**:

```bash
openssl genrsa -out ritmo_distribution_private.key 2048
openssl req -new -key ritmo_distribution_private.key -out ritmo_distribution.csr -subj '/CN=RITMO iOS Distribution'
```

En Apple Developer → Certificates, crea un certificado **Apple Distribution**, sube `ritmo_distribution.csr` y descarga el `.cer`.

Convierte el certificado a PEM y empaquétalo en PKCS#12:

```bash
openssl x509 -inform DER -in distribution.cer -out distribution.pem
openssl pkcs12 -export -inkey ritmo_distribution_private.key -in distribution.pem -out ritmo_distribution.p12 -name 'Apple Distribution RITMO'
```

OpenSSL solicitará una contraseña: esta será `IOS_P12_PASSWORD`. Si Apple entrega el certificado ya en PEM, omite `-inform DER`. Si falla la exportación, verifica que la CSR subida proviene **exactamente de esa clave**.

En Apple Developer → Profiles, crea un perfil de distribución **App Store Connect** vinculado al App ID explícito de RITMO y al certificado Apple Distribution. Descarga el `.mobileprovision`.

**No subas al repositorio:** `ritmo_distribution_private.key`, el `.p12`, el `.mobileprovision`, ni ninguna clave `.p8`. Guarda copias privadas cifradas de estos materiales: si pierdes la clave privada tendrás que emitir otro certificado y actualizar el perfil.

## Clave API de subida a TestFlight

App Store Connect → Users and Access → Integrations → App Store Connect API. Si tu cuenta todavía no tiene acceso a API, el titular debe solicitarlo. Crea una **Team API Key** con permisos suficientes para subir builds. Descarga `AuthKey_<KEY_ID>.p8` cuando se genere (Apple solo permite una descarga) y guarda su Key ID e Issuer ID.

Para más detalles: https://developer.apple.com/documentation/AppStoreConnectAPI/creating-api-keys-for-app-store-connect-api
