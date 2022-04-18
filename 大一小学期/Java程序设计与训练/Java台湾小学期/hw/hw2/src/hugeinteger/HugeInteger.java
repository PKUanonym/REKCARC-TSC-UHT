package hugeinteger;

import java.util.*;
import java.io.*;

class HugeInteger
{
    private int max_size = 41;
    public int size;
    public boolean sign;
    int[] data;
    HugeInteger(String input)
    {
       // System.out.println(input);
        int length = input.length();
        if (length > 40)
            input = input.substring(1);
        data = new int[max_size];
        for (int i = 0;i < max_size;i++)
            data[i] = 0;
        
        char[] x = input.toCharArray();
        
        length = input.length();
        size = length;

        if (size > 40)
            size = 40;
        
        sign = true;
        if (x[0] == '-')
        {
            sign = false;
            size = size - 1;
            for (int i = length-1;i > 0;i--)
                data[length-1-i] = x[i] - '0';

        }
        else 
        {
            for (int i = length-1;i >= 0;i--)
                data[length-1-i] =x[i] - '0';
        }
        

        //for (int i = length-1;i >=0;i--)
          //  System.out.println(data[i]);
    }

    void input(String iii)
    {
        for (int i = 0;i < 40;i++)
            data[i] = 0;
        
        char[] x = iii.toCharArray();
        int length = iii.length();
        if (length > 40)
            length = 40;
        size = length;
        sign = true;

        if (x[0] == '-')
        {
            sign = false;
            size = size - 1;
            for (int i = length-1;i > 0;i--)
                data[length-1-i] = x[i] - '0';

        }
        else 
        {
            for (int i = length-1;i >= 0;i--)
                data[length-1-i] =x[i] - '0';
        }

    }

    void output()
    {
        String s = "";
        //System.out.println(size);
        for (int i = size-1;i >= 0;i--)
            s += data[i];
        if (sign == false)
            s = "-"+s;
        System.out.println(s);
    }

    boolean isEqualTo(HugeInteger x)
    {
        if (this.sign != x.sign)
            return false;
        if (this.size != x.size)
            return false;
        for (int i = 0;i < size;i++)
            if (this.data[i] != x.data[i])
                return false;
        return true;
    }

    boolean isNotEqualTo(HugeInteger x)
    {
        return !isEqualTo(x);
    }

    boolean isGreaterThan(HugeInteger x)
    {
        if (this.sign && !x.sign)
            return true;
        else if (!this.sign && x.sign)
            return false;
        else if (this.size > x.size)
            return true;
        else if (this.size < x.size)
            return false;
        else      
        {
            for (int i = size-1;i >= 0;i--)
                if (this.data[i] > x.data[i])
                    return true;
                else if (this.data[i] < x.data[i])
                    return false;
            return false;
        }
    }

    boolean isLessThan(HugeInteger x)
    {
        return isNotEqualTo(x) && (!isGreaterThan(x));
    }

    boolean isGreaterThanOrEqualTo(HugeInteger x)
    {
        return (isGreaterThan(x) || isEqualTo(x));
    }

    boolean isLessThanOrEqualTo(HugeInteger x)
    {
        return (isLessThan(x) || isEqualTo(x));
    }

    HugeInteger TwoPositiveadd(HugeInteger x)
    {
        int length = 0;
        if (this.size > x.size)
            length = this.size;
        else
            length = x.size;
        int[] ans;
        ans = new int[41];
        int c = 0;
        if (length > 40)
            length = 40;
        for (int i = 0;i <= length;i++)
        {
            ans[i] = this.data[i] + x.data[i] + c;
            c = ans[i] / 10;
            ans[i] = ans[i] % 10;
        }
        String s = "";
        if (ans[length] == 0)
            length -= 1;
        for (int i = length;i >= 0;i--)
            s += ans[i];
        //System.out.println(s);

        HugeInteger nn = new HugeInteger(s);
        return nn;
        
    }

    HugeInteger Twopositivesub(HugeInteger x)
    {
        boolean sign = true;
        if (this.isLessThan(x))
            sign = false;

        int length;
        if (sign)
            length = this.size;
        else 
            length = x.size;
        HugeInteger ans = new HugeInteger("0000");
        if (sign)
        {
            for (int i = 0;i < length;i++)
                ans.data[i] = this.data[i] - x.data[i];
        }
        else
        {
            for (int i = 0;i < length;i++)
                ans.data[i] = x.data[i] - this.data[i];
        }

        int c = 0;
        for (int i = 0;i < length;i++)
        {
            ans.data[i] -= c;
            c = 0;
            if (ans.data[i] < 0)
            {
                ans.data[i] += 10;
                c = 1;
            }
               
        }
        if (sign)
            ans.sign = true;
        else
            ans.sign = false;
        
        ans.size = 41;
        for (int i = 40;i >= 0;i--)
        {
            //System.out.println(i);
            if (ans.data[i] == 0)
                ans.size -= 1;
            else 
                break;
        }
            
        if (ans.size == 0)
            ans.size = 1;

        return ans;
    }

    HugeInteger add(HugeInteger x)
    {
        if (this.sign && x.sign)
            return TwoPositiveadd(x);
        else if (this.sign && !x.sign)
        {
            HugeInteger xx = new HugeInteger("0000");
            for (int i = 0;i < 40;i++)
                xx.data[i] = x.data[i];
            xx.sign = true;
            xx.size = x.size;
            return Twopositivesub(xx);
        }
        else if (!this.sign && x.sign)
        {
            this.sign = true;
            HugeInteger ans = this.Twopositivesub(x);
            this.sign = false;
            ans.sign = !ans.sign;
            return ans;
            
        }
        else 
        {
            this.sign = true;
            x.sign = true;
            HugeInteger ans = this.TwoPositiveadd(x);
            ans.sign = false;
            this.sign = false;
            x.sign = false;
            return ans;
        }
    }

    HugeInteger sub(HugeInteger x)
    {
        if(this.sign && x.sign)
            return this.Twopositivesub(x);
        else if (this.sign && !x.sign)
        {
            x.sign = true;
            HugeInteger ans = this.TwoPositiveadd(x);
            x.sign = false;
            return ans;
        }
        else if (!this.sign && x.sign)
        {
            this.sign = true;
            HugeInteger ans = this.TwoPositiveadd(x);
            ans.sign = false;
            this.sign = false;
            return ans;
        }
        else 
        {
            this.sign = true;
            x.sign = true;
            HugeInteger ans = this.Twopositivesub(x);
            this.sign = false;
            x.sign = false;
            ans.sign = !ans.sign;
            return ans;
        }
    }

}