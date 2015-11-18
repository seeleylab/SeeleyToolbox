#!/usr/bin/env python

import sys
import numpy as np

def main():
    tempderiv(str(sys.argv[1]))

def tempderiv(file):
    ts = []
    prefix = file.rsplit('.')[0]
    f=open(file)
    for line in f:
        val = line.rstrip()
        ts.append(val)
    ts_new = []
    for t in ts:
        cur = []
        for v in t.split():
            cur.append(float(v))
        ts_new.append(cur)
    tsa = np.array(ts_new)
    derivs = []
    for n in range(np.shape(tsa)[1]):
        col = tsa[:,n]
        col_dm = col - np.mean(col)
        deriv = np.gradient(col_dm)
        derivs.append(deriv)
    derivs = np.vstack(derivs).T
    out = np.hstack((tsa,derivs))
    np.savetxt('%s_tempderiv.txt'%prefix, out)
    
if __name__ == "__main__":
    main()
