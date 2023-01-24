# COMPILER INFO
TYPE := .cpp
CC_CPP := gcc
ifeq ($(TYPE),.c)
        CC_CPP := gcc
else
        CC_CPP := clang++
endif

CROSS:=TRUE
ifeq ($(CROSS),TRUE)
 CC_CPP:=g++
endif
FLG := -g -Wall -lpthread
# PATHS AND FILES INFO
MAIN_SRC_PATH = src/
MAIN_BIN_PATH = bin/
# main path
TST_SRC_PATH = t_src/
TST_BIN_PATH = t_bin/
# library path
LIB_PATH = lib/
OBJ_PATH = obj/
# external libraries
EXTR_LIB_PATH = ../lab_libs/

SUB_LIBS=$('python3 lib_scan_h.py')
SUB_OBJS=$('python3 obj_scan_o.py')

# LD_LIBS=-lpthread
# genarate file paths
MAIN_SRC = $(wildcard $(MAIN_SRC_PATH)*$(TYPE))
MAIN_BIN = $(patsubst $(MAIN_SRC_PATH)%$(TYPE),$(MAIN_BIN_PATH)%,$(MAIN_SRC))

TST_SRC = $(wildcard $(TST_SRC_PATH)*$(TYPE))
TST_BIN = $(patsubst $(TST_SRC_PATH)%$(TYPE),$(TST_BIN_PATH)%,$(TST_SRC))

LIBS_SRC = $(wildcard $(LIB_PATH)*$(TYPE))
LIBS_OBJ = $(patsubst $(LIB_PATH)%$(TYPE),$(OBJ_PATH)%.o,$(LIBS_SRC))
LIBS_HDR = $(wildcard $(LIB_PATH)*.h)

EXTR_OBJ = $(wildcard $(EXTR_LIB_PATH)*.o)

SUB_LIBS=$(shell python3 lib_scan_h.py)
SUB_OBJS=$(shell python3 obj_scan_o.py)

# SUB_LIBS = $(wildcard $(LIB_PATH)/*.o)

# Extrenal Library Conflict
# EXTR_OBJ_EX_HEAD = LIBS_OBJ_HEAD - EXTR_OBJ_HEAD heads of exclusive headers in lib
# libraries in the /lib folder is used if it extst in the ../lab_libs
LIBS_OBJ_HEAD=$(patsubst $(OBJ_PATH)%.o,%.o,$(LIBS_OBJ))
EXTR_OBJ_HEAD=$(patsubst $(EXTR_LIB_PATH)%.o,%.o,$(EXTR_OBJ))

EXTR_OBJ_EX_HEAD=$(filter-out $(LIBS_OBJ_HEAD),$(EXTR_OBJ_HEAD))
EXTR_OBJ_EX=$(patsubst %.o,$(EXTR_LIB_PATH)%.o,$(EXTR_OBJ_EX_HEAD))

gen_vars:
	clear
	
	@echo $(LIBS_OBJ_HEAD)
	@echo

	@echo $(EXTR_OBJ_HEAD)
	@echo

	@echo $(EXTR_OBJ_EX)

# GENERATOR MAKE FUNCTIONS
all : all_msg libs bins tests
all_no_msg : bin_dirs $(LIBS_OBJ) $(MAIN_BIN) $(TST_BIN)
all_msg :
recu_libs :

init : src_dirs init_msg readme make_scripts
init_msg :
	@echo
	@echo " Project init"
	@echo " Creating Source directories"
	@echo
	@echo "  "$(LIB_PATH)
	@echo "  "$(TST_SRC_PATH)
	@echo "  "$(MAIN_SRC_PATH)
	@echo "  "$(EXTR_LIB_PATH)
	@echo
	
bin_dirs :
	@mkdir -p $(OBJ_PATH) $(TST_BIN_PATH) $(MAIN_BIN_PATH)
src_dirs :
	@mkdir -p $(LIB_PATH) $(TST_SRC_PATH) $(MAIN_SRC_PATH)

readme :
	@echo "put your library source files \nhere eg: libXXX$(TYPE)pp libXXX.h\noutput files will be generated at "$(OBJ_PATH) > $(LIB_PATH)/read_me.txt
	@echo "put your test codes here\noutputs will be generated at "$(TST_BIN_PATH) > $(TST_SRC_PATH)/read_me.txt
	@echo "put your source codes here\noutputs will be generated at "$(MAIN_BIN_PATH) > $(MAIN_SRC_PATH)/read_me.txt

make_scripts :
	@sudo chmod +x *.py
	@echo $(SUB_LIBS)
	@echo $(SUB_OBJS)
bins : bin_msg bin_dirs $(MAIN_BIN)
bin_msg :
	@echo
	@echo [ BINARIES ]
	@echo
	@echo - Src Path: $(MAIN_SRC_PATH)
	@echo - Bin Path: $(MAIN_BIN_PATH)
	@echo
	
libs : libs_msg bin_dirs $(LIBS_OBJ)
libs_msg :
	@echo
	@echo [ LIBRARIES ]
	@echo
	@echo - Path: $(LIB_PATH)
	@echo

tests : tests_msg bin_dirs $(TST_BIN)
tests_msg :
	@echo
	@echo [ TESTS ]
	@echo
	@echo - Path: $(TST_BIN_PATH)
	@echo

clean:
	@rm -rf $(OBJ_PATH) $(TST_BIN_PATH) $(MAIN_BIN_PATH)
clean_tests:
	@rm -rf $(TST_BIN_PATH)

# GENERATOR RULES -COMPILING

# LIBRARIES
$(OBJ_PATH)%.o : $(LIB_PATH)%$(TYPE) $(LIBS_HDR)
	@echo " > "$<
	$(CC_CPP) $(FLG) -c $< -o $@ -I $(EXTR_LIB_PATH) $(SUB_LIBS)

# TESTS
$(TST_BIN_PATH)% : $(TST_SRC_PATH)%$(TYPE) $(LIBS_OBJ)
	@echo " > "$<
	$(CC_CPP) $(FLG) -o $@ $^ $(EXTR_OBJ_EX) $(SUB_OBJS) -I $(LIB_PATH) -I $(EXTR_LIB_PATH) $(SUB_LIBS)

# MAIN
$(MAIN_BIN_PATH)% : $(MAIN_SRC_PATH)%$(TYPE) $(LIBS_OBJ)
	@echo " > "$<
	$(CC_CPP) $(FLG) -o $@ $^ $(EXTR_OBJ_EX) $(SUB_OBJS) -I $(LIB_PATH) -I $(EXTR_LIB_PATH) $(SUB_LIBS)
