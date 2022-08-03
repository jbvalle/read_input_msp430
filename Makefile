# Hardware  specific
DEVICE = msp430fr4133
DRIVER = tilib

# Dependencies
INC_DIR = ./inc

# Compiler and Debugging Variables
CC = msp430-elf-gcc
GDB = mspdebug
GDB_ELF = msp430-elf-gdb
TARGET_GDB_SCRIPT = msp430.gdb

# -g3 includes macro information
# -gdwarf-2 includes debugger information needed by the target gdb in DWARF Debugger Format
CFLAGS = -I . -I$(INC_DIR) -mmcu=$(DEVICE) -g3 -gdwarf-2 -mhwmult=auto
LFLAGS = -L . -L$(INC_DIR)

SRCS = $(wildcard *.c)

OBJF = obj
_OBJ_ = $(SRCS:%.c=%.o)
OBJ = $(patsubst %, $(OBJF)/%, $(_OBJ_))

TARGET = main.elf

all: $(TARGET)

$(OBJF)/%.o: %.c | mk_obj
	$(CC) $(CFLAGS) $(LFLAGS) -c $^ -o $@

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(LFLAGS) -o $@ $^

install: $(TARGET)
	$(GDB) $(DRIVER) "prog $^" --allow-fw-update

debug_init:
	$(GDB) $(DRIVER) gdb &

debug_start:
	$(GDB_ELF) -q $(TARGET) -x $(TARGET_GDB_SCRIPT)

clean:
	rm -rf $(OBJ)

mk_obj:
	mkdir -p $(OBJF)

help:
	@echo "+--------------------------------------------------------------------------------+"
	@echo "  make && make install   	| for compiling and flashing board        			 "
	@echo "  make clean             	| for deleting obj and binaries files     			 "
	@echo "  make debug_init        	| Starts debugger and listens for default gdb port	 "
	@echo "  make debug_start        	| Tells debugger to start debuggin executable		 "
	@echo "+--------------------------------------------------------------------------------+"

.PHONY = clean mk_obj debug_start debug_init
