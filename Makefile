NAME=setup

SRC_DIR=src
SRC=$(SRC_DIR)/main.sh \
	$(SRC_DIR)/parse.sh \
	$(SRC_DIR)/do_apt.sh \
	$(SRC_DIR)/do_web.sh \
	$(SRC_DIR)/do_swap.sh \
	$(SRC_DIR)/do_restore.sh \
	$(SRC_DIR)/run.sh
RESOURCES=resource

BIN_DIR=~/.local/bin
RESOURCES_DIR=~/.local/share/setup

GREEN=\033[0;32m
NC=\033[0m

all: $(NAME)

$(NAME): $(SRC)
	@echo -n "Creating $@..."
	@cat $(SRC) > $@
	@chmod +x $@
	@echo "[$(GREEN) OK $(NC)]"

install: $(NAME)
	@echo -n "Installing $(NAME)..."
	@cp $(NAME) $(BIN_DIR)
	@mkdir $(RESOURCES_DIR)
	@cp -r $(RESOURCES) $(RESOURCES_DIR)
	@echo "[$(GREEN) OK $(NC)]"

link_install: $(NAME)
	@echo -n "Installing $(NAME)..."
	@ln -s $(PWD)/$(NAME) $(BIN_DIR)/$(NAME)
	@mkdir $(RESOURCES_DIR)
	@ln -s $(PWD)/$(RESOURCES) $(RESOURCES_DIR)/$(RESOURCES)
	@echo "[$(GREEN) OK $(NC)]"

uninstall:
	@echo -n "Uninstalling $(NAME)..."
	@rm $(BIN_DIR)/$(NAME)
	@rm -r $(RESOURCES_DIR)
	@echo "[$(GREEN) OK $(NC)]"

clean:
	@echo -n "Cleaning..."
	@rm $(NAME)
	@echo "[$(GREEN) OK $(NC)]"
