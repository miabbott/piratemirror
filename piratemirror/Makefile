.PHONY: install
install:
    sudo cp piratemirror.sysconfig /etc/sysconfig/piratemirror
    sudo cp piratemirror.service /etc/systemd/system/piratemirror.service
    sudo cp piratemirror.timer /etc/systemd/system/piratemirror.timer
    sudo systemctl systemctl daemon-reload
    sudo systemctl systemctl enable piratemirror.timer --now
