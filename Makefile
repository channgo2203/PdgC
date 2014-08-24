###########################################################################
#                              SigCert Makefile
#                  Copyright (C) 2012-2013  Chan Ngo
#
#
###########################################################################

OCAMLMAKEFILE = OCamlMakefile

SOURCES = src/tututil.ml \
		  src/ciltut.ml \
          src/ciltutoptions.ml \
          src/tut0.ml \
          src/tut1.ml \
          src/main.ml 

RESULT = PdgC

LIBS = str unix nums cil

INCDIRS = /usr/local/lib/ocaml/site-lib/cil

LIBDIRS = /usr/local/lib/ocaml/site-lib/cil

YFLAGS = -v

all: native-code

-include $(OCAMLMAKEFILE)
