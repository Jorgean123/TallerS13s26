# Verificación del laboratorio

Validado el 5 de noviembre de 2026 en el entorno local:

- Compilación Maven: BUILD SUCCESS; WAR generado en `target/laboratorio26.war`.
- Despliegue: Payara Micro 6.2025.1, Java 11, puerto 8086.
- Página inicial: HTTP 200 y renderizado de componentes JSF / BootsFaces.
- Base `laboratorio26` y tabla `contactos` creadas en MySQL 8.
- Saludo: POST Ajax devuelve XML `partial-response` con el nombre enviado.
- Campos obligatorios: rechazo de formulario vacío.
- Guardado válido: confirmación y contacto incorporado al directorio.
- Duplicado: rechazo del mismo correo.
- Persistencia: contacto disponible en una petición nueva después de recargar.

Pruebas reproducibles: `scripts/verificar.ps1`. Se dejó un contacto de prueba identificado por `lab26-test-…@example.test`.

Las pruebas se hicieron mediante peticiones HTTP reales contra JSF y MySQL. La inspección visual en navegador y la interacción a tamaño móvil quedan como comprobaciones manuales descritas en README.md.
