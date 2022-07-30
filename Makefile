# Hardware  specific
DEVICE = msp430fr4133
DRIVER = tilib

# Dependencies
INC_DIR = ./inc

# Compiler Variables
CC = msp430-elf-gcc
CFLAGS = -I . -I$(INC_DIR) -mmcu=$(DEVICE) -g -mhwmult=auto
LFLAGS = -L . -L$(INC_DIR)

SRCS = $(wildcard *.c)

OBJF = obj
_OBJ_ = $(SRCS:%.c=%.o)
OBJ = $(patsubst %, $(OBJF)/%, $(_OBJ_))

TARGET = main

all: $(TARGET)

$(OBJF)/%.o: %.c | mk_obj
	$(CC) $(CFLAGS) $(LFLAGS) -c $^ -o $@

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(LFLAGS) -o $@ $^

install: $(TARGET)
	mspdebug $(DRIVER) "prog $^" --allow-fw-update

clean:
	rm -rf $(OBJ)

mk_obj:
	mkdir -p $(OBJF)

show:
	echo $(OBJ)

.PHONY = clean mk_obj
