package tableElements;

import javafx.beans.property.SimpleStringProperty;

public class RSRow {
    private SimpleStringProperty name;
    private SimpleStringProperty busy;
    private SimpleStringProperty op;
    private SimpleStringProperty vj;
    private SimpleStringProperty vk;
    private SimpleStringProperty qj;
    private SimpleStringProperty qk;

    public RSRow(String a) {
        name = new SimpleStringProperty();
        busy = new SimpleStringProperty();
        op = new SimpleStringProperty();
        vj = new SimpleStringProperty();
        vk = new SimpleStringProperty();
        qj = new SimpleStringProperty();
        qk = new SimpleStringProperty();
        setName(a);
    }

    public String getName() {
        return name.get();
    }

    public void setName(String name) {
        this.name.set(name);
    }

    public String getBusy() {
        return busy.get();
    }

    public SimpleStringProperty busyProperty() {
        return busy;
    }

    public void setBusy(String busy) {
        this.busy.set(busy);
    }

    public String getOp() {
        return op.get();
    }

    public SimpleStringProperty opProperty() {
        return op;
    }

    public void setOp(String op) {
        this.op.set(op);
    }

    public String getVj() {
        return vj.get();
    }

    public SimpleStringProperty vjProperty() {
        return vj;
    }

    public void setVj(String vj) {
        this.vj.set(vj);
    }

    public String getVk() {
        return vk.get();
    }

    public SimpleStringProperty vkProperty() {
        return vk;
    }

    public void setVk(String vk) {
        this.vk.set(vk);
    }

    public String getQj() {
        return qj.get();
    }

    public SimpleStringProperty qjProperty() {
        return qj;
    }

    public void setQj(String qj) {
        this.qj.set(qj);
    }

    public String getQk() {
        return qk.get();
    }

    public SimpleStringProperty qkProperty() {
        return qk;
    }

    public void setQk(String qk) {
        this.qk.set(qk);
    }
}
