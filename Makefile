prefix=/usr
bindir=$(prefix)/bin
datadir=$(prefix)/share

INSTALL_DIRNAME = gtk-android-builder
INSTALL_DIR = $(prefix)/opt/$(INSTALL_DIRNAME)

all:
	@echo "No compile needed, run 'make install' to install the project."

install:
	@echo "Installing project to $(DESTDIR)$(INSTALL_DIR)"
	install -Dm755 -t $(DESTDIR)$(INSTALL_DIR) pixiewood
	cp -rf prepare/ generate/ $(DESTDIR)/$(INSTALL_DIR)/
	ln -sf $(INSTALL_DIR)/pixiewood $(DESTDIR)$(bindir)/pixiewood
	install -Dm644 -t $(DESTDIR)$(datadir)/xml/pixiewood/ pixiewood.xsd

uninstall:
	@echo "Attempting to uninstall project"
	rm -rf $(INSTALL_DIR)
	unlink $(bindir)/pixiewood || true
	rm -rf $(datadir)/xml/pixiewood

.PHONY: all install uninstall
