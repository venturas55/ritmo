# Checklist de revisión

## Comprobado en este checkout
- [x] Funciones, navegación, validación de nombre/días/hora y almacenamiento examinados.
- [x] Sin cuentas, backend, pagos ni publicación de contenido en código propio.
- [x] Cambios limitados a fuente y documentación; sin builds, despliegues, commits ni pushes.
- [x] TypeScript correcto antes y después de cambios.
- [x] Diff sin errores de espacios.
- [x] URLs de privacidad y soporte responden HTTP 200 desde comprobación externa autorizada. Esto no acredita validez del contenido ni entrega de correo.
- [x] No hay scripts de tests o lint configurados. No se instala infraestructura.

## Obligatorio completar personalmente
- [ ] Comparar texto exacto de Apple y responder todos sus apartados.
- [ ] Identificar commit/build realmente enviado; distinguir correcciones locales.
- [ ] Probar instalación y apertura, persistencia tras reinicio y modo avión.
- [ ] Crear/editar/eliminar hábitos, validaciones y navegación con teclado.
- [ ] Probar calendario, meses, cambio de día, zonas horarias y rachas.
- [ ] Probar avisos permitidos/denegados, edición, borrado y volumen de notificaciones.
- [ ] Probar JSON, cancelación de compartir, doble toque y borrado de copias internas.
- [ ] Probar borrado total y reapertura sin datos ni avisos.
- [ ] Probar privacidad en Safari y correo configurado/no configurado.
- [ ] Verificar VoiceOver, tamaño de texto, botones y pantallas pequeñas.
- [ ] Completar identidad real, política definitiva, soporte operativo y tratamiento de backups.
- [ ] Revisar privacidad de SDK, PrivacyInfo.xcprivacy/APIs y ficha de privacidad del IPA existente.
- [ ] Confirmar precio, territorios, edad y distribución en App Store Connect.
- [ ] Confirmar derechos de marca, iconos, imágenes y licencias.
- [ ] Capturas reales, metadatos completos, vídeo físico accesible y notas en inglés sin marcadores.

No se declara aprobación garantizada ni validación nativa mediante TypeScript. Expo Doctor y expo install --check no ejecutados: diagnósticos opcionales, sin cambios de dependencias autorizados.

- [x] Tres pruebas de regresión de Ajustes correctas con adaptadores simulados; sin dependencias nuevas.
- [x] Web pública: privacidad contiene «borrador» y «Datos que faltan»; soporte contiene «Antes de hacer». Contenido definitivo pendiente.
