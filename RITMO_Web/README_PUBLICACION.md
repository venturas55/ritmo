# RITMO · Web para GitHub Pages

Web estática independiente de Expo, preparada para alojarse en el repositorio existente `venturas55/ritmo` bajo la carpeta `docs/`.

## Instalación

1. Copia la carpeta `docs` de este ZIP en la raíz de tu repositorio local `ritmo-project` (no sustituyas `app/`, `src/` ni `.github/`).
2. Reemplaza todas las apariciones de `CONTACTO_PENDIENTE` y `RESPONSABLE_PENDIENTE` en `docs/soporte.html` y `docs/privacidad.html` por información real. El contacto debe funcionar.
3. Revisa la política de privacidad con el comportamiento final de tu build iOS (permisos, dependencias/analíticas, transferencias y RGPD); el texto es un borrador publicable **solo tras verificar y completar**.
4. En PowerShell: `git add docs; git commit -m "Add RITMO product, support and privacy website"; git push origin main`.
5. En GitHub: repositorio → **Settings → Pages** → **Build and deployment** → **Deploy from a branch** → `main` → `/docs` → **Save**.
6. Espera a que GitHub Pages se publique y prueba estos enlaces:
   - Inicio: https://venturas55.github.io/ritmo/
   - Soporte: https://venturas55.github.io/ritmo/soporte.html
   - Privacidad: https://venturas55.github.io/ritmo/privacidad.html

## Enlaces para App Store Connect

- **Support URL:** `https://venturas55.github.io/ritmo/soporte.html`
- **Privacy Policy URL:** `https://venturas55.github.io/ritmo/privacidad.html`
- **Marketing URL (opcional):** `https://venturas55.github.io/ritmo/`

Las URLs funcionarán solo después de habilitar Pages y publicar la rama/carpeta indicadas. La visibilidad de Pages puede ser pública aunque tu repositorio de código sea privado, según la disponibilidad de tu plan: compruébalo en la configuración.

## Cambiar los enlaces en React Native

En el archivo `app/(tabs)/settings.tsx` de tu versión inicial existían estas constantes provisionales:

```typescript
const support='mailto:dev@guardiandelfaro.es?subject=Soporte%20Ritmo';
const privacy='https://guardiandelfaro.es/proyectos/ritmo/privacidad';
```

Sustitúyelas por:

```typescript
const support='https://venturas55.github.io/ritmo/soporte.html';
const privacy='https://venturas55.github.io/ritmo/privacidad.html';
```

Si prefieres contacto directo por email en la app, utiliza `mailto:` con una dirección verdadera y operativa. Tras este cambio necesitarás generar una nueva build para que los enlaces queden actualizados en iOS.

## Diseño

HTML + CSS, sin librerías JS, sin cookies analíticas, adaptable a móvil. La vista de teléfono de portada es una **ilustración conceptual**, no una captura de la app. Para App Store Connect usa capturas reales del iPhone.
