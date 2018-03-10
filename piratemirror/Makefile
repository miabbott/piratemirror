NAME := piratemirror

.PHONY: install
install:
	cp $(NAME).sysconfig /etc/sysconfig/$(NAME)
	cp $(NAME).service /etc/systemd/system/$(NAME).service
	cp $(NAME).timer /etc/systemd/system/$(NAME).timer
	systemctl daemon-reload
	systemctl enable $(NAME).timer --now
