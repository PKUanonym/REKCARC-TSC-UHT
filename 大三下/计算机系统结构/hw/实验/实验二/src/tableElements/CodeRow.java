package tableElements;

import javafx.beans.property.SimpleStringProperty;

/**
 * Created by Jiahui Huang on 2017/5/26.
 */
public class CodeRow {
    private SimpleStringProperty id;
    private SimpleStringProperty content;
    private SimpleStringProperty st1;
    private SimpleStringProperty st2;
    private SimpleStringProperty st3;

    public CodeRow(int idx, String code) {
        this.id = new SimpleStringProperty(String.valueOf(idx));
        this.content = new SimpleStringProperty(code);
        this.st1 = new SimpleStringProperty();
        this.st2 = new SimpleStringProperty();
        this.st3 = new SimpleStringProperty();
    }

    public String getId() {
        return id.get();
    }

    public SimpleStringProperty idProperty() {
        return id;
    }

    public void setId(String id) {
        this.id.set(id);
    }

    public String getContent() {
        return content.get();
    }

    public SimpleStringProperty contentProperty() {
        return content;
    }

    public void setContent(String content) {
        this.content.set(content);
    }

    public String getSt1() {
        return st1.get();
    }

    public SimpleStringProperty st1Property() {
        return st1;
    }

    public void setSt1(String st1) {
        this.st1.set(st1);
    }

    public String getSt2() {
        return st2.get();
    }

    public SimpleStringProperty st2Property() {
        return st2;
    }

    public void setSt2(String st2) {
        this.st2.set(st2);
    }

    public String getSt3() {
        return st3.get();
    }

    public SimpleStringProperty st3Property() {
        return st3;
    }

    public void setSt3(String st3) {
        this.st3.set(st3);
    }
}
