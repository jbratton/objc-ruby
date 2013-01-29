CC := clang
CFLAGS := -g
FRAMEWORKS := -framework Foundation -framework Ruby
BUILD_DIR := build
SOURCES := EmbeddedRuby.m EmbeddedRubyIO.m main.m
HEADERS := $(SOURCES:%.m=%.h)
OBJECTS := $(addprefix $(BUILD_DIR)/,$(SOURCES:%.m=%.o))
INCLUDES := -I /System/Library/Frameworks/Ruby.framework/Headers/
EXEC := $(BUILD_DIR)/emuby
RM := rm -rf
NOOP := 

all: $(SOURCES) $(EXEC) $(OBJECTS)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(EXEC): $(OBJECTS)
	$(CC) $(CFLAGS) $(FRAMEWORKS) $(INCLUDES) $(OBJECTS) -o $@

$(OBJECTS): $(HEADERS) | $(BUILD_DIR)

$(BUILD_DIR)/%.o: %.m
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(HEADERS):
	$(NOOP)

.PHONY: clean
clean:
	$(RM) $(EXEC) $(OBJECTS) $(BUILD_DIR)
