HCMPATH=$(shell pwd)/../

CXXFLAGS=-std=c++11 -Wall -pedantic -ggdb -O0 -fPIC -I$(HCMPATH)/include -I$(HCMPATH)/flattener -I$(HCMPATH)/sigvec -I$(HCMPATH)/hcm_vcd
CFLAGS=-std=c++11 -Wall -pedantic -ggdb -O0 -fPIC -I$(HCMPATH)/include -I$(HCMPATH)/flattener -I$(HCMPATH)/sigvec -I$(HCMPATH)/hcm_vcd
CC=g++
LDFLAGS=-L$(HCMPATH)/src -lhcm -Wl,-rpath=$(HCMPATH)/src  -L$(HCMPATH)/sigvec -lhcmsigvec  -Wl,-rpath=$(HCMPATH)/sigvec -L$(HCMPATH)/hcm_vcd

all: event_sim

event_sim: HW2ex1.o
	$(CC) -o $@ $^ $(LDFLAGS) $(HCMPATH)/flattener/flat.o $(HCMPATH)/hcm_vcd/vcd.o

clean:
	 @ rm *.o event_sim
