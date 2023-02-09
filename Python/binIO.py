#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import numpy as np
import os
import struct


# In[ ]:


def readin_bin(path=None, seek_num=None, nt=None, nr=None):
    FA = open(path, "rb")
    FA.seek(seek_num)
    out_data = np.empty((nt,nr))
#         for tt in range(self.nt):
    for rr in range(nr):
        for tt in range(nt):
            data = FA.read(4)
            data_float = struct.unpack("f", data)[0]
            out_data[tt][rr] = data_float
    return out_data


# In[ ]:


def writeout_bin(path=None, in_data=None, seek_num=None, nt=None, nr=None):
    FA = open(path, "wb")
#     FA.seek(seek_num)
#     out_data = np.empty((nt,nr))
#         for tt in range(self.nt):
    for rr in range(nr):
        for tt in range(nt):
            data = in_data[tt][rr] #FA.read(4)
            data_float = struct.pack("f", data)
#             out_data[tt][rr] = data_float
            FA.write(data_float)
    FA.close()


# In[1]:




# In[ ]:




