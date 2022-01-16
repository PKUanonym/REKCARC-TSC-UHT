import java.io.BufferedInputStream;
import java.util.*;

class Main {
    public static void main(String[] args) {
        Scanner in = new Scanner(new BufferedInputStream(System.in));
        HashMap<BaseStaff, Integer> staff = new HashMap<BaseStaff, Integer>();
        int n = in.nextInt(), m = in.nextInt();
        in.nextLine();
        for (int i = 0; i < n; i++)
            staff.computeIfAbsent(new Staff(in.nextLine()), k -> 0);

        for (int i = 0; i < m; i++) {
            Staff input = new Staff(in.nextLine());
            staff.computeIfPresent(input, (key, value) -> value + 1);
        }
        List<Map.Entry<BaseStaff, Integer>> list = new ArrayList(staff.entrySet());
        Collections.sort(list, (o1, o2) -> (o2.getValue() - o1.getValue()));
        System.out.println(list.get(0).getKey().toString());
        System.out.println("BaseStaff.checkCreate()=" + BaseStaff.checkCreate());
    }
}

// abstract class BaseStaff {
//     /**
//      * Get the type of this staff.
//      * 
//      * @return a String, "Teacher" or "Student"
//      */
//     public abstract String getType();

//     /**
//      * Get the number of this staff.
//      * 
//      * @return an int, teacher number or student number
//      */
//     public abstract int getNumber();

//     @Override
//     public int hashCode() {
//         return (getType() + getNumber()).hashCode();
//     }

//     @Override
//     public boolean equals(final Object obj) {
//         return obj instanceof BaseStaff && getType().equals(((BaseStaff) obj).getType())
//                 && getNumber() == ((BaseStaff) obj).getNumber();
//     }
// }

class Staff extends BaseStaff {
    int count;
    String type;
    String info[];

    Staff(String str) {
        this.info = str.split(" ");
        this.type = info[0];
        if (this.type.length() == 1)
            this.type = this.type.equals("S") ? "Student" : "Teacher";
    }

    public String getType() {
        return this.type;
    }

    public int getNumber() {
        return Integer.parseInt(info[1]);
    }

    @Override
    public String toString() {
        String out = new String(type);
        for (int i = 1; i < this.info.length; i++)
            out += " " + this.info[i];
        return out;
    }
}