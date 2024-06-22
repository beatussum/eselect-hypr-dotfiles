VERSION	:::= $(shell date "+%Y%m%d")

DESTDIR		?=
PREFIX		?= $(DESTDIR)/usr/local
SYSCONFDIR	?= $(DESTDIR)/etc

CONFIGDIR	?= $(SYSCONFDIR)/eselect/hypr-dotfiles
DOTFILESDIR	?= $(CONFIGDIR)/dotfiles
ESELECTDIR	?= $(PREFIX)/share/eselect/modules

BUILDDIR	?= build

INSTALLDIR_CMD	?= install -d
INSTALLFILE_CMD	?= install -m0644
RMDIR_CMD		?= rm -fr
SED_CMD			?= sed

.PHONY: all
all: $(BUILDDIR)/hypr-dotfiles.eselect

$(BUILDDIR):
	$(INSTALLDIR_CMD) $@

$(BUILDDIR)/hypr-dotfiles.eselect: src/hypr-dotfiles.eselect.in $(BUILDDIR)
	$(SED_CMD) "s/@VERSION@/$(VERSION)/g" $< > $@

.PHONY: clean
clean:
	$(RMDIR_CMD) $(BUILDDIR)

.PHONY: install
install: $(BUILDDIR)/hypr-dotfiles.eselect
	$(INSTALLDIR_CMD) $(CONFIGDIR)
	$(INSTALLDIR_CMD) $(DOTFILESDIR)

	$(INSTALLDIR_CMD) $(ESELECTDIR)
	$(INSTALLFILE_CMD) $(BUILDDIR)/hypr-dotfiles.eselect $(ESELECTDIR)
