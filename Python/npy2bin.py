## convert npy into binary
import numpy as np
from binIO import writeout_bin

def npy2bin(path=None, oupath=None, seek_num=0, nt=None, nr=None):
  # read in npy
  indata = np.load(path)
#  print(f"debug:{indata}, {indata.dtype}, {indata.shape}")
  vcom = np.zeros( (1,2,nt,nr-2))
  vcom[0,0,:,:] = indata[0,0,:,0:-2] + indata[0,0,:,1:-1]
  vcom[0,1,:,:] = indata[0,1,:,0:-2] + indata[0,1,:,1:-1]
  for ii in range(nt-1):
    vcom[0,0,ii,:] = vcom[0,0,ii,:] - np.median(vcom[0,0,ii,:])
    vcom[0,1,ii,:] = vcom[0,1,ii,:] - np.median(vcom[0,1,ii,:])
  writeout_bin(path=oupath+'_vz.bin', in_data=vcom[0,0,:,:], seek_num=seek_num, nt=nt, nr=nr-2)
  writeout_bin(path=oupath+'_vx.bin', in_data=vcom[0,1,:,:], seek_num=seek_num, nt=nt, nr=nr-2)
  return
