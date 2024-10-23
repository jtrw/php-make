# Colours vars
C_GREEN=\033[0;32m
C_RED=\033[0;31m
C_YELLOW=\033[0;33m
C_END=\033[0m

colorRed = "$(C_RED)$(1)$(C_END)"
colorGreen = "$(C_GREEN)$(1)$(C_END)"
colorYellow = "$(C_YELLOW)$(1)$(C_END)"


define print_info
 $(call print, $(1), "green")
endef

define print_warning
 $(call print, $(1), "yellow")
endef

define print_error
 $(call print, $(1), "red")
endef

define print
 @case ${2} in \
  green)    echo "\033[0;32m${1}\033[0m" ;; \
  red)     echo "\033[0;31m${1}\033[0m" ;; \
  yellow)  echo "\033[0;33m${1}\033[0m" ;; \
  *)       echo "\e[97m${1}\e[0m" ;; \
 esac
endef

test_colors:
	$(call print_info, "That\'s an information only.")
	$(call print_warning, "That\'s a warning. Maybe you should do something.")
	$(call print_error, "That\'s an error. Do something! Now!")
