# LIBRARIES
# Additional Imports
# ..List...
# Own Libs
# ..List...
# Compilation
# ..Worker...

libs_main : libs_setup print_lib_intro lib_sub_container lib_own_hdr libs_worker

libs_setup: bin_dirs
	@date>>"$(LOG_PATH)libs_builds.log"

### Additional Libraries
lib_sub_container_intro:
	@echo ⤵ Additional/Sub Libraries
lib_sub_container_main: print_sub_lib_hdr print_sub_lib_obj

lib_sub_container:lib_sub_container_intro lib_sub_container_main

print_sub_lib_hdr : 
	@ for item in $(shell python3 helper/lib_scan_h.py list); do \
		echo '-' $$item;\
	done

print_sub_lib_obj : 
	@ for item in $(shell python3 helper/lib_scan_o.py list); do \
		echo '-' $$item;\
	done

### Own Libraries
lib_own_intro:

lib_own_hdr_intro:
lib_own_hdr: lib_own_hdr_intro print_lib_hdr

lib_own_obj_intro:
	@echo Expected Targets

lib_own_hdr: lib_own_obj_intro print_lib_obj

print_lib_hdr:
	@echo Libraries Owned
		@ for item in $(LIBS_HDR); do \
		echo '-' $$item;\
	done
print_lib_obj:
	@ for item in $(LIBS_OBJ); do \
		echo '-' $$item;\
	done
print_lib_intro:
	@echo "$(CYAN)$(BOLD)LIBRARIES$(RESET)"

libs_worker_intro:
	@echo Compiling own libraries
# this may not work as its part of the sub make file
libs_worker: libs_worker_intro $(LIBS_OBJ)
libs_logs:
	@echo "$(YELLOW)$(LOG_PATH)libs_builds.log$(RESET)"
libs_close:libs_logs
	@echo "$(GREEN)Done$(RESET)" $(DONE)