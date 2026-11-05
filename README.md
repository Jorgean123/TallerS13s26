# Laboratorio 26: componentes BootsFaces y Ajax

Semana 13 · Sesión 26 · Universidad Tecnológica del Perú.

## Implementación

- Página responsiva con `b:container`, `b:row`, `b:column` y `b:panelGrid`.
- Panel informativo plegable con faceta `footer` y panel de advertencia.
- Saludo mediante `f:ajax event="keyup"`, procesamiento `@this` y actualización exclusiva de `panelResultado`, con demora de 250 ms.
- Registro corporativo en panel `primary`: nombre, correo y teléfono obligatorios y validados en servidor.
- Guardado Ajax, confirmación inferior `success` y directorio actualizado sin recarga completa.
- Persistencia MySQL mediante JDBC, consultas parametrizadas y correo único. La confirmación solo aparece después de un INSERT exitoso.
- Cuestionario resuelto en la página y en este documento.

## Correcciones de la ficha

La biblioteca se llama **BootsFaces** y su namespace es `http://bootsfaces.net/ui`, no `http://bootfaces.net/ui`.
La versión 2.0.1 requiere Jakarta Faces 4 / Jakarta EE 10. No se debe desplegar este WAR en GlassFish 5 o Payara 5 (Java EE / javax).
Se utiliza Java 11 y APIs Jakarta EE 10. Puede abrirse como proyecto Maven en NetBeans o IntelliJ y desplegarse en GlassFish 7 o Payara 6. Maven incluye automáticamente el JAR en `WEB-INF/lib`.

Referencias oficiales: [inicio rápido y namespace](https://www.bootsfaces.net/quick-start.jsf), [compatibilidad de BootsFaces 2](https://github.com/TheCoder4eu/BootsFaces-OSP), [artefacto 2.0.1](https://central.sonatype.com/artifact/net.bootsfaces/bootsfaces/2.0.1).

## Ejecución local

1. Inicie MySQL y ejecute `database/schema.sql` con MySQL Workbench. Es idempotente: no elimina registros existentes.
2. Ejecute `INICIAR.cmd`. Compila el WAR, descarga Payara Micro 6.2025.1 si hace falta y solicita la contraseña de MySQL sin guardarla en el proyecto.
3. Abra http://localhost:8086/laboratorio26/ . Para detener el proceso iniciado por el script, pulse Ctrl+C en su consola.

Requisitos: JDK 11, Maven, MySQL 8 y acceso a Maven Central para la primera compilación. El script detecta las rutas locales de NetBeans 12/JDK 11; en otra máquina configure JAVA_HOME y Maven en PATH. Si el puerto está ocupado, use `powershell -File scripts/iniciar.ps1 -Puerto 8087`.

Configuración JDBC mediante variables de entorno o propiedades Java del servidor:

| Variable | Valor predeterminado |
|---|---|
| LAB26_DB_URL | jdbc:mysql://localhost:3306/laboratorio26?connectionTimeZone=America/Lima&connectTimeout=5000&socketTimeout=10000 |
| LAB26_DB_USER | root |
| LAB26_DB_PASSWORD | Sin valor; debe configurarse antes de iniciar el servidor |

Para GlassFish 7, configure las variables en el entorno del proceso que inicia el dominio y despliegue `target/laboratorio26.war` desde NetBeans o con `asadmin deploy`. Las credenciales no se incluyen en el WAR.

El iniciador local configura una URL JDBC sin TLS exclusivamente para MySQL en localhost, evitando incompatibilidades con el almacén SSL de Payara. Para una base remota configure LAB26_DB_URL con TLS y certificados apropiados.

Prueba funcional automatizada con el servidor iniciado: `powershell -ExecutionPolicy Bypass -File scripts/verificar.ps1`. Verifica respuestas parciales, campos obligatorios, registro, duplicados y persistencia. Genera un contacto claramente identificado con correo `@example.test`.

## Autoevaluación

1. **Atributo:** `xmlns:b="http://bootsfaces.net/ui"`, declarado en `html`, asocia el prefijo `b` con los componentes BootsFaces.
2. **look:** aplica un estilo contextual al panel (primary, info, success, warning, danger, default) para distinguir su función visual.
3. **Ajax:** permite enviar datos y actualizar fragmentos de la página en segundo plano. Reduce transferencias y evita una recarga completa, conservando el contexto visual. JSF sigue ejecutando el ciclo de vida para los componentes incluidos en `execute`, y devuelve los incluidos en `render`.

## Comprobación manual

1. Plegar y desplegar el panel informativo.
2. Escribir un nombre y comprobar el saludo sin recarga.
3. Enviar campos vacíos: deben aparecer mensajes y no insertarse filas.
4. Probar correo y teléfono inválidos.
5. Registrar un contacto válido: aparece confirmación y una fila nueva.
6. Repetir su correo: aparece el error de duplicado sin nueva fila.
7. Recargar: el contacto permanece en MySQL.
8. En DevTools / Network verificar peticiones POST Ajax y respuestas XML `partial-response`, sin navegación Document.
9. Revisar a 375 px de ancho: las columnas deben apilarse y la tabla permitir desplazamiento horizontal.
