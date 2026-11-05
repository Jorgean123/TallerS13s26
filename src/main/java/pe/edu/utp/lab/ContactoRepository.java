package pe.edu.utp.lab;

import jakarta.enterprise.context.ApplicationScoped;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@ApplicationScoped
public class ContactoRepository {
    private String config(String key, String fallback) {
        String value = System.getProperty(key);
        if (value == null) value = System.getenv(key);
        return value == null ? fallback : value;
    }
    private Connection connect() throws SQLException {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { throw new SQLException("No se encuentra MySQL Connector/J", e); }
        return DriverManager.getConnection(
            config("LAB26_DB_URL", "jdbc:mysql://localhost:3306/laboratorio26?connectionTimeZone=America/Lima&connectTimeout=5000&socketTimeout=10000"),
            config("LAB26_DB_USER", "root"), config("LAB26_DB_PASSWORD", ""));
    }
    public void guardar(String nombre, String correo, String telefono) throws SQLException {
        try (Connection c = connect(); PreparedStatement p = c.prepareStatement(
                "INSERT INTO contactos(nombre, correo, telefono) VALUES (?, ?, ?)")) {
            p.setString(1, nombre); p.setString(2, correo); p.setString(3, telefono);
            p.executeUpdate();
        }
    }
    public List<Contacto> listar() throws SQLException {
        List<Contacto> contactos = new ArrayList<>();
        try (Connection c = connect(); PreparedStatement p = c.prepareStatement(
                "SELECT id, nombre, correo, telefono FROM contactos ORDER BY id DESC LIMIT 100");
                ResultSet r = p.executeQuery()) {
            while (r.next()) contactos.add(new Contacto(r.getLong(1), r.getString(2), r.getString(3), r.getString(4)));
        }
        return contactos;
    }
}
