TARGET  = $(notdir $(CURDIR))

SRCEXT	= .cpp
INCEXT	= .h
OBJEXT	= .o

SRCDIR	= src
INCDIR	= include
OBJDIR	= bin

CC	= g++-11
LD	= g++-11

LDFLAGS	= -lm -lpthread
CCFLAGS	= -std=c++2a -Ofast -march=native -w

SRCTREE	= $(shell find $(SRCDIR) -type d)
INCS	= $(shell find $(INCDIR) -type f -name '*$(INCEXT)')
SRCS	= $(shell find $(SRCDIR) -type f -name '*$(SRCEXT)')
OBJTREE	= $(foreach D,$(SRCTREE),$(shell echo $(D) | sed 's/$(SRCDIR)/$(OBJDIR)/'))
OBJSTMP	= $(foreach F,$(SRCS),$(shell echo $(F) | sed -e 's/$(SRCDIR)/$(OBJDIR)/'))
OBJS	= $(foreach O,$(OBJSTMP),$(shell echo $(O) | sed -e 's/\$(SRCEXT)/\$(OBJEXT)/'))

all: $(TARGET)
	@echo Builded.

run: $(TARGET)
	@./$(TARGET)
	@echo Executed.

clean:
	@rm -r $(TARGET) $(OBJS) $(OBJDIR) 2>/dev/null || true
	@echo Cleaned.

$(TARGET): $(OBJS) | $(OBJDIR)
	@$(LD) -L$(OBJDIR) -o $@ $^ $(LDFLAGS)

$(OBJS): $(OBJDIR)/%$(OBJEXT) : $(SRCDIR)/%$(SRCEXT) | $(OBJDIR)
	@$(CC) $(CCFLAGS) -I$(INCDIR) -c -o $@ $?

$(OBJDIR):
	@mkdir -p $(OBJDIR) $(OBJTREE)

# comment

.PHONY: all run clean
