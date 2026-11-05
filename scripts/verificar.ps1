param([string]$Url = 'http://localhost:8086/laboratorio26/')
$ErrorActionPreference = 'Stop'
function Assert-Contains($Text, $Expected) {
    if (-not $Text.Contains($Expected)) { throw "No se encontró: $Expected" }
}
function Post-Ajax($Form, $Fields, $Source, $Render) {
    $page = Invoke-WebRequest $Url -UseBasicParsing -SessionVariable session
    if ($page.Content.Contains('No se pudo cargar')) { throw 'Falló la conexión inicial a MySQL.' }
    $state = [regex]::Match($page.Content, 'name="jakarta.faces.ViewState"[^>]*value="([^"]+)"').Groups[1].Value
    $body = @{'jakarta.faces.partial.ajax'='true'; 'jakarta.faces.source'=$Source; 'jakarta.faces.partial.execute'=$Form; 'jakarta.faces.partial.render'=$Render; 'jakarta.faces.ViewState'=[System.Net.WebUtility]::HtmlDecode($state)}
    $body[$Form]=$Form
    foreach ($key in $Fields.Keys) { $body[$key]=$Fields[$key] }
    $response = Invoke-WebRequest $Url -UseBasicParsing -WebSession $session -Method Post -Headers @{'Faces-Request'='partial/ajax'} -Body $body
    Assert-Contains $response.Content '<partial-response'
    if ($response.Content.Contains('<error>')) { throw $response.Content }
    return $response.Content
}
$saludo = Post-Ajax 'demo' @{'input_demo:nombre'='Prueba Ajax'; 'jakarta.faces.behavior.event'='keyup'; 'jakarta.faces.partial.event'='keyup'} 'demo:nombre' 'demo:panelResultado'
Assert-Contains $saludo 'Hola, Prueba Ajax'
Write-Host 'OK: saludo mediante respuesta parcial JSF.'
$invalid = Post-Ajax 'registro' @{'input_registro:contactoNombre'=''; 'input_registro:correo'=''; 'input_registro:telefono'=''; 'registro:guardar'='Guardar contacto'; 'jakarta.faces.behavior.event'='action'} 'registro:guardar' 'registro'
Assert-Contains $invalid 'Ingrese el nombre del contacto.'
Write-Host 'OK: validación de campos obligatorios.'
$email = 'lab26-test-' + [guid]::NewGuid().ToString('N') + '@example.test'
$fields = @{'input_registro:contactoNombre'='Contacto de prueba Ajax'; 'input_registro:correo'=$email; 'input_registro:telefono'='+51 987 654 321'; 'registro:guardar'='Guardar contacto'; 'jakarta.faces.behavior.event'='action'}
$saved = Post-Ajax 'registro' $fields 'registro:guardar' 'registro'
Assert-Contains $saved 'registrado correctamente en MySQL.'
Assert-Contains $saved $email
Write-Host "OK: registro persistido vía Ajax: $email"
$duplicate = Post-Ajax 'registro' $fields 'registro:guardar' 'registro'
Assert-Contains $duplicate 'Ya existe un contacto con ese correo.'
Write-Host 'OK: bloqueo de correo duplicado.'
$reload = Invoke-WebRequest $Url -UseBasicParsing
Assert-Contains $reload.Content $email
Write-Host 'OK: persistencia después de recargar.'
Write-Host 'El contacto example.test generado queda identificado como dato de prueba.'
