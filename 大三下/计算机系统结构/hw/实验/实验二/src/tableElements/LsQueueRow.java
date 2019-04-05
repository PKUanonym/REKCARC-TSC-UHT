package tableElements;

import javafx.beans.property.SimpleStringProperty;

/**
 * Created by Jiahui Huang on 2017/5/28.
 */
public class LsQueueRow {
    private SimpleStringProperty id;
    private SimpleStringProperty rsName;
    private SimpleStringProperty op;
    private SimpleStringProperty vj;
    private SimpleStringProperty qj;
    private SimpleStringProperty address;

    public LsQueueRow() {
        id = new SimpleStringProperty();
        rsName = new SimpleStringProperty();
        op = new SimpleStringProperty();
        vj = new SimpleStringProperty();
        qj = new SimpleStringProperty();
        address = new SimpleStringProperty();
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

    public String getRsName() {
        return rsName.get();
    }

    public SimpleStringProperty rsNameProperty() {
        return rsName;
    }

    public void setRsName(String rsName) {
        this.rsName.set(rsName);
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

    public String getQj() {
        return qj.get();
    }

    public SimpleStringProperty qjProperty() {
        return qj;
    }

    public void setQj(String qj) {
        this.qj.set(qj);
    }

    public String getAddress() {
        return address.get();
    }

    public SimpleStringProperty addressProperty() {
        return address;
    }

    public void setAddress(String address) {
        this.address.set(address);
    }
}
