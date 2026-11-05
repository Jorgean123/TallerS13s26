package pe.edu.utp.lab;

import java.io.Serializable;

public class Contacto implements Serializable {
    private final long id;
    private final String nombre, correo, telefono;
    public Contacto(long id, String nombre, String correo, String telefono) {
        this.id = id; this.nombre = nombre; this.correo = correo; this.telefono = telefono;
    }
    public long getId() { return id; }
    public String getNombre() { return nombre; }
    public String getCorreo() { return correo; }
    public String getTelefono() { return telefono; }
}
