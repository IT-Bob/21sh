# Nom
NAME = 21sh
PROJECT = 21sh

# Détection de l'OS
OS = $(shell uname -s)

# Options de compilation
CC = @gcc
CFLAGS = -Wall -Werror -Wextra
ifeq ($(OS), Linux)
	CFLAGSUP = -Wno-sign-compare -Wno-empty-body #-g -fsanitize=address
else
	CFLAGSUP = -Wno-sign-compare # -g -fsanitize=address
endif
CPPFLAGS = -I $(INC_PATH) -I $(LIB_INC) -I $(LINE_INC) -I $(ENV_INC)
CLIB = -L $(LINE) -llinput -L $(LIBFT) -lft -L $(ENVIRON) -lenv -ltermcap

# Fichiers d'en-tête
INC_PATH = includes/
INC_FILE = twenty_onesh.h
INC = $(addprefix $(INC_PATH), $(INC_FILE))

# Fichiers sources
SRC_PATH = src/
SRC_FILE = main.c 
SRC = $(addprefix $(SRC_PATH), $(SRC_FILE))
OBJ = $(SRC:.c=.o)

# Fichiers des bibliothèques
LIBFT = modules/libft/
LIB_INC = $(LIBFT)includes/
LIB = $(LIBFT)libft.a

LINE = modules/line_input/
LINE_INC = $(LINE)includes/
LIBLINE = $(LINE)liblinput.a

ENVIRON = modules/environment/
ENV_INC = $(ENVIRON)includes/
LIBENV = $(ENVIRON)libenv.a

# Règles de compilation
all: lib $(NAME)

$(NAME): Makefile $(LIB) $(LIBLINE) $(LIBENV) $(OBJ)
	@echo "$(CYAN)Compilation de $(NAME)$(RESET)"
	@$(CC) $(CFLAGS) $(CPPFLAGS) $(CFLAGSUP) $(OBJ) $(CLIB) -o $(NAME)

$(OBJ): $(INC)

lib:
	@echo "$(VERT)Compilation...$(RESET)"
	@make -C $(LIBFT) all
	@make -C $(LINE) LIBFT_INC=../libft/includes all
	@make -C $(ENVIRON) LIBFT_INC=../libft/includes all

clean: cleanproj
	@make -C $(LIBFT) clean
	@make -C $(LINE) clean
	@make -C $(ENVIRON) clean

fclean: fcleanproj
	@make -C $(LIBFT) fclean
	@make -C $(LINE) fclean
	@make -C $(ENVIRON) fclean

re: fclean all

cleanproj:
	@echo "$(ROUGEC)Suppression des fichiers objets de $(NAME)$(RESET)"
	@rm -f $(OBJ)

fcleanproj: cleanproj
	@echo "$(ROUGEC)Suppression de l'exécutable $(NAME)$(RESET)"
	@rm -f $(NAME)

# Règles pour la norme
norme: cleanproj
	@echo "$(MAGEN)Norme pour $(PROJECT)$(RESET)"
	@norminette includes/ src/

normeall: norme
	@make -C $(LIBFT) norme
	@make -C $(LINE) norme
	@make -C $(ENVIRON) norme

# Règles pour la documentation
doxygen:
	@echo "$(CYAN)Génération de la documentation de $(PROJECT)$(RESET)"
	@$(DOXYGEN) documentation/$(PROJECT).doxyconf > documentation/$(PROJECT).log
#	@echo "$(JAUNE)Pas de fichier de documentation pour $(PROJECT)$(RESET)"
	@make -C $(LIBFT) doxygen $(DOXYGEN)
	@make -C $(LINE) doxygen $(DOXYGEN)
	@make -C $(ENVIRON) doxygen $(DOXYGEN)

cleandoxy:
	@echo "Suppression de la documentation de $(PROJECT)"
	@rm -rf documentation/html
	@rm -rf documentation/$(PROJECT).log
	@make -C $(LIBFT) cleandoxy
	@make -C $(LINE) cleandoxy
	@make -C $(ENVIRON) cleandoxy

fcleanall: cleandoxy fclean

# Couleurs
RESET = \033[0m
BLANC = \033[37m
BLEU  = \033[34m
CYAN  = \033[36m
JAUNE = \033[33m
MAGEN = \033[35m
NOIR  = \033[30m
ROUGE = \033[31m
ROUGEC = \033[1;31m
VERT  = \033[32m

# Variables
DOXYGEN = doxygen

.PHONY: all lib clean fclean re doxygen cleandoxy
