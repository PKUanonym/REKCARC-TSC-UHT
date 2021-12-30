class BinNode {
	BinNode p = null;
	BinNode lc = null;
	BinNode rc = null;
	int v = 0;
	public BinNode(BinNode parent, int value) {
		p = parent;
		v = value;
	}

	public void set_v(int value) {
		v = value;
	}

	public void set_p(BinNode node) {
		p = node;
	}

	public void set_lc(BinNode node) {
		lc = node;
	}

	public void set_rc(BinNode node) {
		rc = node;
	}

	public boolean is_lc() {
		if (p == null)
			return false;
		return p.lc == this;
	}

	public boolean is_rc() {
		if (p == null)
			return false;
		return p.rc == this;
	}

	public boolean has_lc() {
		return lc != null;
	}

	public boolean has_rc() {
		return rc != null;
	}

	public BinNode tree_min() {
		BinNode x = this;
		while (x.lc != null)
			x = x.lc;
		return x;
	}

	public BinNode getRc() {
		return rc;
	}

	public BinNode getLc() {
		return lc;
	}

	public BinNode getP() {
		return p;
	}

	public BinNode succ() {
		if (rc != null)
			return rc.tree_min();
		BinNode y = p;
		BinNode x = this;
		while (y != null && x == y.rc) {
			x = y;
			y = y.p;
		}
		return y;
	}
}
