package tableElements;

import javafx.beans.property.SimpleStringProperty;

/**
 * Created by Jiahui Huang on 2017/5/27.
 */
public class MemRow {
    private SimpleStringProperty offset;
    private SimpleStringProperty value;

    public MemRow() {
        offset = new SimpleStringProperty();
        value = new SimpleStringProperty();
    }

    public String getOffset() {
        return offset.get();
    }

    public SimpleStringProperty offsetProperty() {
        return offset;
    }

    public void setOffset(String offset) {
        this.offset.set(offset);
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
}
