param([int]$Puerto = 8086)
$ErrorActionPreference = 'Stop'
$project = Split-Path $PSScriptRoot -Parent
Set-Location $project
$java = if ($env:JAVA_HOME) { Join-Path $env:JAVA_HOME 'bin/java.exe' } else { 'C:\Program Files\Java\jdk-11\bin\java.exe' }
$maven = 'C:\Program Files\NetBeans-12.0\netbeans\java\maven\bin\mvn.cmd'
if (-not (Test-Path $maven)) { $maven = (Get-Command mvn.cmd).Source }
if (-not $env:JAVA_HOME) { $env:JAVA_HOME = Split-Path (Split-Path $java) }
$env:MAVEN_OPTS = '-Djavax.net.ssl.trustStoreType=Windows-ROOT -Djavax.net.ssl.trustStore=NUL'
& $maven -B package
if ($LASTEXITCODE -ne 0) { throw 'Falló la compilación.' }
New-Item -ItemType Directory -Force .runtime,.local | Out-Null
if (-not (Test-Path .runtime/payara-micro.jar)) {
    Invoke-WebRequest 'https://repo.maven.apache.org/maven2/fish/payara/extras/payara-micro/6.2025.1/payara-micro-6.2025.1.jar' -OutFile .runtime/payara-micro.jar
}
if (-not $env:LAB26_DB_PASSWORD) {
    $secret = Read-Host 'Clave de MySQL (root)' -AsSecureString
    $credential = New-Object System.Net.NetworkCredential('', $secret)
    $env:LAB26_DB_PASSWORD = $credential.Password
}
try {
    if (-not $env:LAB26_DB_URL) {
        $env:LAB26_DB_URL = 'jdbc:mysql://localhost:3306/laboratorio26?sslMode=DISABLED&allowPublicKeyRetrieval=true&connectionTimeZone=America/Lima&connectTimeout=5000&socketTimeout=10000'
    }
    Write-Host "Aplicación: http://localhost:$Puerto/laboratorio26/ (Ctrl+C para detener)"
    & $java -jar .runtime/payara-micro.jar --port $Puerto --nocluster --deploy target/laboratorio26.war
} finally { Remove-Item Env:LAB26_DB_PASSWORD -ErrorAction SilentlyContinue }
