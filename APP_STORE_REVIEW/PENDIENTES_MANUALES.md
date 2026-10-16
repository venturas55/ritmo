# Pendientes manuales y decisión sobre IPA

## Antes de responder a Apple
1. Aportar mensaje íntegro de Guideline 2.1. Solo se conoce resumen de solicitud; no puede certificarse cobertura literal de preguntas no facilitadas.
2. Identificar build enviado y commit correspondiente. Ejecutar guion físico con ese build; adjuntar vídeo accesible. No existen credenciales demo que proporcionar.
3. Completar identidad legal real del responsable. Un email no identifica por sí solo al responsable. Confirmar dev@guardiandelfaro.es operativo y titularidad del dominio. Las páginas locales incluyen avisos de borrador; no eliminarlos sin resolver contenido. HTTP 200 no acredita política final.
4. Confirmar proveedor de hosting, logs web, Google Fonts, correo de soporte, conservación de mensajes, copias de seguridad iOS/iCloud y destinatarios elegidos para exportación. Revisar política y declaraciones de App Store Connect contra IPA real; no afirmar «sin datos recopilados» basándose solo en código propio.
5. Revisar manifiestos de privacidad/licencias del artefacto ya existente sin recompilarlo; confirmar SDK y APIs de motivo obligatorio. No se han modificado dependencias ni ajustes nativos. Cualquier cambio futuro de esos archivos requiere autorización previa.
6. Confirmar público general, territorios, precio, edad, derechos de assets y metadatos/capturas. No se detectan actividades reguladas ni catálogo protegido, pero titularidad requiere confirmación del propietario.
7. Probar todos los flujos de CHECKLIST_REVISION.md, especialmente denegación de avisos, borrado y exportación. No se ha utilizado iPhone físico ni simulador.

## ¿Nuevo IPA?
La petición de información 2.1 puede contestarse con el build ya presentado si sus funciones reales son correctas y la respuesta/vídeo describen ese build. Documentación y una política web corregida por su responsable pueden resolverse sin incorporar código al IPA.

Las correcciones de esta auditoría solo existen en el checkout. Para que usuarios y Apple reciban cambios de fuente, se necesita generar y enviar un nuevo IPA con el proceso actual. Se recomienda incluirlas antes de afirmar que «Eliminar todos mis datos» borra también los JSON internos. No describir esas correcciones como presentes en el build antiguo sin comprobarlo. Apple puede pedir otro build; no se garantiza que baste una respuesta.

No se ha iniciado build, publicación ni despliegue. Workflows, firma, credenciales e identificadores deben seguir intactos. Sin commits ni pushes automáticos.
