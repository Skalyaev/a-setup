NAME=setup

SRC_DIR=src
SRC=$(SRC_DIR)/main.sh \
	$(SRC_DIR)/parse.sh \
	$(SRC_DIR)/do_apt.sh \
	$(SRC_DIR)/do_web.sh \
	$(SRC_DIR)/do_swap.sh \
	$(SRC_DIR)/do_restore.sh \
	$(SRC_DIR)/run.sh
BIN_DIR=~/.local/bin

RESOURCES=resource
RESOURCES_DIR=~/.local/share/setup

GREEN=\033[0;32m
NC=\033[0m

all: $(NAME)

$(NAME): $(SRC)
	@echo -n "Creating $@..."
	@cat $(SRC) > $@
	@chmod +x $@
	@echo -n "\r"
	@echo "$@ [ $(GREEN)created$(NC) ]"

install: $(NAME)
	@echo -n "Installing $(NAME)..."
	@mkdir -p $(BIN_DIR)
	@cp $(NAME) $(BIN_DIR)
	@mkdir -p $(RESOURCES_DIR)
	@cp -r $(RESOURCES) $(RESOURCES_DIR)
	@echo -n "\r"
	@echo "$(NAME) [ $(GREEN)installed$(NC) ]"

link_install: $(NAME)
	@echo -n "Installing $(NAME)..."
	@mkdir -p $(BIN_DIR)
	@ln -s $(PWD)/$(NAME) $(BIN_DIR)/$(NAME)
	@mkdir -p $(RESOURCES_DIR)
	@ln -s $(PWD)/$(RESOURCES) $(RESOURCES_DIR)/$(RESOURCES)
	@echo -n "\r"
	@echo "$(NAME) [ $(GREEN)installed$(NC) ]"

uninstall:
	@echo -n "Uninstalling $(NAME)..."
	@rm -f $(BIN_DIR)/$(NAME)
	@rm -rf $(RESOURCES_DIR)
	@echo -n "\r"
	@echo "$(NAME) [ $(GREEN)uninstalled$(NC) ]"

clean:
	@echo -n "Removing $(NAME)..."
	@rm -f $(NAME)
	@echo -n "\r"
	@echo "$(NAME) [ $(GREEN)removed$(NC) ]"
