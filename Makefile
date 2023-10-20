include helper/Styles.mk
include helper/makelib.mk
include helper/makebin.mk
include helper/maketst.mk
# COMPILER INFO
TYPE := .cpp
CC_CPP := gcc
ifeq ($(TYPE),.c)
        CC_CPP := gcc
else
        CC_CPP := g++
endif

CROSS:=TRUE
ifeq ($(CROSS),TRUE)
 CC_CPP:=g++
endif
FLG := -g -Wall -pthread

# Configure the paths here
# PATHS AND FILES INFO
MAIN_SRC_PATH = src/
MAIN_BIN_PATH = bin/
# main path
TST_SRC_PATH = t_src/
TST_BIN_PATH = t_bin/
# library path
LIB_PATH = lib/
OBJ_PATH = obj/
# Log Path
LOG_PATH = logs/
# external libraries
EXTR_LIB_PATH = ../lab_libs/


# LD_LIBS=-lpthread

# Generated Paths
# main directories
# main source file path *c and *cpp files
MAIN_SRC = $(wildcard $(MAIN_SRC_PATH)*$(TYPE))
# the generated output paths
MAIN_BIN = $(patsubst $(MAIN_SRC_PATH)%$(TYPE),$(MAIN_BIN_PATH)%,$(MAIN_SRC))

# test directories
TST_SRC = $(wildcard $(TST_SRC_PATH)*$(TYPE))
TST_BIN = $(patsubst $(TST_SRC_PATH)%$(TYPE),$(TST_BIN_PATH)%,$(TST_SRC))

# library paths
# own lib paths
# ie libraries that belongs to this project
LIBS_SRC = $(wildcard $(LIB_PATH)*$(TYPE))
LIBS_OBJ = $(patsubst $(LIB_PATH)%$(TYPE),$(OBJ_PATH)%.o,$(LIBS_SRC))
LIBS_HDR = $(wildcard $(LIB_PATH)*.h)

# sublibraries this will take sublibraries which are part of the current project
# eg lib/subproject/lib/..
SUB_LIBS_HDR=$(shell python3 helper/lib_scan_h.py)
SUB_LIBS_OBJ=$(shell python3 helper/lib_scan_o.py)
SUB_LIBS_SRC=$(shell python3 helper/lib_scan_path.py)
# the below macros are only used for displaying / echoing

EXTR_OBJ = $(wildcard $(EXTR_LIB_PATH)*.o)

# libraries in the /lib folder is used if it extst in the ../lab_libs

SUB_LIB_HDRS = $(wildcard $(LIB_PATH)/*.o)

# Extrenal Library Conflict
# EXTR_OBJ_EX_HEAD = LIBS_OBJ_HEAD - EXTR_OBJ_HEAD heads of exclusive headers in lib

LIBS_OBJ_HEAD=$(patsubst $(OBJ_PATH)%.o,%.o,$(LIBS_OBJ))
EXTR_OBJ_HEAD=$(patsubst $(EXTR_LIB_PATH)%.o,%.o,$(EXTR_OBJ))

EXTR_OBJ_EX_HEAD=$(filter-out $(LIBS_OBJ_HEAD),$(EXTR_OBJ_HEAD))
EXTR_OBJ_EX=$(patsubst %.o,$(EXTR_LIB_PATH)%.o,$(EXTR_OBJ_EX_HEAD))

gen_vars: print_sub_lib_hdr print_sub_lib_obj
		
# GENERATOR MAKE FUNCTIONS
all : all_msg libs bins tsts
all_no_msg : bin_dirs $(LIBS_OBJ) $(MAIN_BIN) $(TST_BIN)
all_msg :
	clear

init : src_dirs init_msg readme helper_init
init_msg :
	@echo "Project init"
	@echo "Creating Source directories"
	@echo "- "$(LIB_PATH)
	@echo "- "$(TST_SRC_PATH)
	@echo "- "$(MAIN_SRC_PATH)
	@echo "- "$(EXTR_LIB_PATH)
	
bin_dirs :
	@mkdir -p $(OBJ_PATH) $(TST_BIN_PATH) $(MAIN_BIN_PATH) $(LOG_PATH)
src_dirs :
	@mkdir -p $(LIB_PATH) $(TST_SRC_PATH) $(MAIN_SRC_PATH) $(LOG_PATH)

readme :
	@echo "put your library source files \nhere eg: libXXX$(TYPE)pp libXXX.h\noutput files will be generated at "$(OBJ_PATH) > $(LIB_PATH)/read_me.txt
	@echo "put your test codes here\noutputs will be generated at "$(TST_BIN_PATH) > $(TST_SRC_PATH)/read_me.txt
	@echo "put your source codes here\noutputs will be generated at "$(MAIN_BIN_PATH) > $(MAIN_SRC_PATH)/read_me.txt

helper_init :
	@sudo chmod +x *.py
	@echo $(SUB_LIB_HDRS)
	@echo $(SUB_LIBS_OBJ)

libs : libs_main $(LIBS_OBJ) libs_close
bins : bins_main $(MAIN_BIN) bins_close
tsts : tsts_main $(TST_BIN) tsts_close
# 	@date>>"logs/tests_builds.log"
clean:
	@rm -rf $(OBJ_PATH) $(TST_BIN_PATH) $(MAIN_BIN_PATH)
	@rm -rf $(LOG_PATH)
clean_tests:
	@rm -rf $(TST_BIN_PATH)

pd_export:
	cp bin/* /home/hermit/pandora_box/bin
# GENERATOR RULES -COMPILING

# LIBRARIES
$(OBJ_PATH)%.o : $(LIB_PATH)%$(TYPE) $(LIBS_HDR)
	
	@echo "---$<---" >> "$(LOG_PATH)libs_builds.log"

#	for compiling libraries you only need to compile the c/cpp file not the objects of other libraries
	@($(CC_CPP) $(FLG) -c $< -o $@ $(SUB_LIBS_SRC) 2>> "$(LOG_PATH)libs_builds.log" && echo - $< $(DONE))||(echo - $< $(FAIL) && echo $(LOG_PATH)libs_builds.log &&exit 1)

# TESTS
$(TST_BIN_PATH)% : $(TST_SRC_PATH)%$(TYPE) $(LIBS_OBJ) $(SUB_LIBS_OBJ)
	
	@echo "---$<---" >> "$(LOG_PATH)tests_builds.log"
	@($(CC_CPP) $(FLG) -o $@ $^ -I $(LIB_PATH) $(SUB_LIBS_SRC) 2>>"$(LOG_PATH)tests_builds.log" && echo - $< $(DONE))||(echo - $< $(FAIL) &&  exit 1)

# MAIN
$(MAIN_BIN_PATH)% : $(MAIN_SRC_PATH)%$(TYPE) $(LIBS_OBJ) $(SUB_LIBS_OBJ)

	@echo "---$<---">> "$(LOG_PATH)main_build.log"
	@($(CC_CPP) $(FLG) -o $@ $^ -I $(LIB_PATH) $(SUB_LIBS_HDR) $(SUB_LIBS_SRC) 2>>"$(LOG_PATH)main_build.log" && echo - $< $(DONE))||(echo - $< $(FAIL) && exit 1)
