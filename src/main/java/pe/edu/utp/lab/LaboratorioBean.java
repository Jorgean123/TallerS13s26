package pe.edu.utp.lab;

import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;

@Named("bean") @ViewScoped
public class LaboratorioBean implements Serializable {
    private static final Logger LOG = Logger.getLogger(LaboratorioBean.class.getName());
    @Inject private ContactoRepository repository;
    private String nombre = "", contactoNombre = "", correo = "", telefono = "", resultado = "";
    private List<Contacto> contactos = Collections.emptyList();
    @PostConstruct public void cargar() {
        try { contactos = repository.listar(); }
        catch (SQLException e) { error("No se pudo cargar el directorio. Verifique la conexión a MySQL.", e); }
    }
    public void guardar() {
        resultado = "";
        try {
            repository.guardar(contactoNombre.trim(), correo.trim().toLowerCase(Locale.ROOT), telefono.trim());
            resultado = "Contacto de " + contactoNombre.trim() + " registrado correctamente en MySQL.";
            contactoNombre = ""; correo = ""; telefono = "";
        } catch (SQLException e) {
            error(e.getErrorCode() == 1062 ? "Ya existe un contacto con ese correo." : "No se pudo guardar el contacto. Intente nuevamente.", e);
            return;
        }
        cargar();
    }
    private void error(String mensaje, SQLException e) {
        LOG.log(Level.WARNING, "Operación de contactos fallida; SQLState={0}, código={1}", new Object[]{e.getSQLState(), e.getErrorCode()});
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, mensaje, null));
    }
    public String getNombre() { return nombre; }
    public void setNombre(String value) { nombre = value; }
    public String getContactoNombre() { return contactoNombre; }
    public void setContactoNombre(String value) { contactoNombre = value; }
    public String getCorreo() { return correo; }
    public void setCorreo(String value) { correo = value; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String value) { telefono = value; }
    public String getResultado() { return FacesContext.getCurrentInstance().isValidationFailed() ? "" : resultado; }
    public List<Contacto> getContactos() { return contactos; }
}
