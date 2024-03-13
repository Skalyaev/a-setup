NAME=setup
SRC_DIR=src
SRC=$(SRC_DIR)/main.sh \
	$(SRC_DIR)/parse.sh \
	$(SRC_DIR)/do_apt.sh \
	$(SRC_DIR)/do_web.sh \
	$(SRC_DIR)/do_swap.sh \
	$(SRC_DIR)/do_restore.sh \
	$(SRC_DIR)/run.sh

GREEN=\033[0;32m
NC=\033[0m

all: $(NAME)

$(NAME): $(SRC)
	@echo -n "Creating $@..."
	@cat $(SRC) > $@
	@chmod +x $@
	@echo -n "\r"
	@echo "$@ [ $(GREEN)created$(NC) ]"

clean:
	@echo -n "Removing $(NAME)..."
	@rm -f $(NAME)
	@echo -n "\r"
	@echo "$(NAME) [ $(GREEN)removed$(NC) ]"
