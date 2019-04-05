#ifndef OPERATION_H
#define OPERATION_H

#include <QDebug>

class operation
{
public:
    int oldVal;
    int newVal;
    int *oldPosb;
    int *newPosb;
    int gridx;
    int gridy;
public:
	operation(const operation& c):
		operation()
	{
		oldVal = c.oldVal;
		newVal = c.newVal;
		gridx = c.gridx;
		gridy = c.gridy;
		if (oldPosb)
		{
			delete oldPosb;
			oldPosb = NULL;
		}
		if (newPosb)
		{
			delete newPosb;
			newPosb = NULL;
		}

		if (c.oldPosb)
		{
			oldPosb = new int[9];
			for (int i = 0; i < 9; i++)
				oldPosb[i] = c.oldPosb[i];
		}
		if (c.newPosb)
		{
			newPosb = new int[9];
			for (int i = 0; i < 9; i++)
				newPosb[i] = c.newPosb[i];
		}
	}
	operation()
	{
		oldVal = 0;
		newVal = 0;
		oldPosb = NULL;
		newPosb = NULL;
		gridx = 0;
		gridy = 0;
	}
    operation(int a, int b, int x, int y)
    {
        oldVal=a;
        newVal=b;
        oldPosb=NULL;
        newPosb=NULL;
        gridx=x;
        gridy=y;
    }
    operation(int *a, int *b, int x, int y)
    {
        oldVal=0;
        newVal=0;
        oldPosb=new int[9];
        newPosb=new int[9];
        for(int i=0; i<9; i++)
        {
            oldPosb[i]=a[i];
            newPosb[i]=b[i];
        }
        gridx=x;
        gridy=y;
    }
    ~operation()
    {
		if(oldPosb)
			delete oldPosb;
		if(newPosb)
			delete newPosb;
    }
	operation& operator=(const operation& c)
	{
		oldVal = c.oldVal;
		newVal = c.newVal;
		gridx = c.gridx;
		gridy = c.gridy;
		if (oldPosb)
		{
			delete oldPosb;
			oldPosb = NULL;
		}
		if (newPosb)
		{
			delete newPosb;
			newPosb = NULL;
		}

		if (c.oldPosb)
		{
			oldPosb = new int[9];
			for (int i = 0; i < 9; i++)
				oldPosb[i] = c.oldPosb[i];
		}
		if (c.newPosb)
		{
			newPosb = new int[9];
			for (int i = 0; i < 9; i++)
				newPosb[i] = c.newPosb[i];
		}
		return *this;
	}
};

#endif // OPERATION_H
