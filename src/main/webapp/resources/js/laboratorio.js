function registroAjax(data) {
    var button = document.getElementById('registro:guardar');
    var status = document.getElementById('estadoEnvio');
    if (button) button.disabled = data.status === 'begin';
    if (status) status.textContent = data.status === 'begin' ? 'Guardando…' : 'Guardado asíncrono en MySQL';
}
window.addEventListener('load', function () {
    if (window.faces) faces.ajax.addOnError(function () {
        var button = document.getElementById('registro:guardar');
        if (button) button.disabled = false;
        var status = document.getElementById('estadoEnvio');
        if (status) status.textContent = 'Error de comunicación. Recargue para comprobar si el contacto se guardó antes de reintentar.';
    });
});
