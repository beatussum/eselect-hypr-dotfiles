VERSION	:::= $(shell date "+%Y%m%d")

DESTDIR		?=
PREFIX		?= /usr/local
SYSCONFDIR	?= /etc

CONFIGDIR	?= $(SYSCONFDIR)/eselect/hypr-dotfiles
DOTFILESDIR	?= $(CONFIGDIR)/dotfiles
ESELECTDIR	?= $(PREFIX)/share/eselect/modules

BUILDDIR	?= build
SPECDATADIR	?= spec/data

CPCMD				?= cp -ar
INSTALLMKDIRCMD	?= install -d
INSTALLFILECMD		?= install -D -m0644
RMDIRCMD			?= rm -fr
SEDCMD				?= sed
SHELLSPECCMD		?= shellspec

.PHONY: all
all: $(BUILDDIR)/hypr-dotfiles.eselect

$(BUILDDIR):
	$(INSTALLMKDIRCMD) $@

$(BUILDDIR)/hypr-dotfiles.eselect: src/hypr-dotfiles.eselect.in $(BUILDDIR)
	$(SEDCMD) "s/@VERSION@/$(VERSION)/g" $< > $@

.PHONY: clean
clean:
	$(RMDIRCMD) $(BUILDDIR)

.PHONY: test
test: $(BUILDDIR)/hypr-dotfiles.eselect
	$(INSTALLMKDIRCMD) $(BUILDDIR)/fakeroot/$(DOTFILESDIR)
	$(CPCMD) $(SPECDATADIR)/* $(BUILDDIR)/fakeroot/$(DOTFILESDIR)/

	$(SHELLSPECCMD)

.PHONY: install
install: $(BUILDDIR)/hypr-dotfiles.eselect
	$(INSTALLMKDIRCMD) $(DESTDIR)/$(DOTFILESDIR)
	
	$(INSTALLFILECMD) \
		$(BUILDDIR)/hypr-dotfiles.eselect \
		$(DESTDIR)/$(ESELECTDIR)/hypr-dotfiles.eselect
