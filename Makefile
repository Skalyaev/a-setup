NAME=setup
SRC_DIR=srcs
SRC=$(SRC_DIR)/root/main.sh \
	$(SRC_DIR)/root/parsing.sh \
	$(SRC_DIR)/root/do_apt.sh \
	$(SRC_DIR)/root/do_web.sh \
	$(SRC_DIR)/root/do_swap.sh \
	$(SRC_DIR)/root/do_restore.sh \
	$(SRC_DIR)/root/run.sh

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
