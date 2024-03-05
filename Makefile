NAME=setup
SRC_DIR=srcs
SRC=$(SRC_DIR)/root/main.sh \
	$(SRC_DIR)/root/parsing.sh \
	$(SRC_DIR)/ui/terminal.sh \
	$(SRC_DIR)/ui/ide.sh \
	$(SRC_DIR)/ui/gui.sh \
	$(SRC_DIR)/ui/browser.sh \
	$(SRC_DIR)/ui/tools.sh \
	$(SRC_DIR)/pentest/info_gathering.sh \
	$(SRC_DIR)/pentest/vuln_analysis.sh \
	$(SRC_DIR)/pentest/web_analysis.sh \
	$(SRC_DIR)/pentest/db_assessment.sh \
	$(SRC_DIR)/pentest/passw_atk.sh \
	$(SRC_DIR)/pentest/exploitation.sh \
	$(SRC_DIR)/pentest/privesc.sh \
	$(SRC_DIR)/pentest/sniffing.sh \
	$(SRC_DIR)/pentest/spoofing.sh \
	$(SRC_DIR)/pentest/wireless_atk.sh \
	$(SRC_DIR)/pentest/reverse.sh \
	$(SRC_DIR)/pentest/report.sh \
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
