package tableElements;

import javafx.beans.property.SimpleStringProperty;

/**
 * Created by Jiahui Huang on 2017/5/27.
 */
public class FPRegRow {
    private SimpleStringProperty name;
    private SimpleStringProperty value;
    private SimpleStringProperty rs;

    public FPRegRow(String name) {
        this.name = new SimpleStringProperty(name);
        this.value = new SimpleStringProperty();
        this.rs = new SimpleStringProperty();
    }

    public String getName() {
        return name.get();
    }

    public SimpleStringProperty nameProperty() {
        return name;
    }

    public void setName(String name) {
        this.name.set(name);
    }

    public String getValue() {
        return value.get();
    }

    public SimpleStringProperty valueProperty() {
        return value;
    }

    public void setValue(String value) {
        this.value.set(value);
    }

    public String getRs() {
        return rs.get();
    }

    public SimpleStringProperty rsProperty() {
        return rs;
    }

    public void setRs(String rs) {
        this.rs.set(rs);
    }
}
