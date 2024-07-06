VERSION	= $(shell date "+%Y%m%d")

DESTDIR		?=
PREFIX		?= /usr/local
SYSCONFDIR	?= /etc

ESELECTCONFDIR	?= $(DESTDIR)/$(SYSCONFDIR)/eselect/hypr-dotfiles
CONFDIR			?= $(ESELECTCONFDIR)/configs
ESELECTDIR		?= $(DESTDIR)/$(PREFIX)/share/eselect/modules

BUILDDIR	?= build
SPECDATADIR	?= spec/data

CPCMD			?= cp -ar
INSTALLMKDIRCMD	?= install -d
INSTALLFILECMD	?= install -D -m0644
RMDIRCMD		?= rm -fr
SEDCMD			?= sed
SHELLSPECCMD	?= shellspec

.PHONY: all
all: $(BUILDDIR)/hypr-dotfiles.eselect

$(BUILDDIR):
	$(INSTALLMKDIRCMD) $@

$(BUILDDIR)/hypr-dotfiles.eselect: src/hypr-dotfiles.eselect.in $(BUILDDIR)
	$(SEDCMD) "s/@VERSION@/$(VERSION)/g" $< > $@

.PHONY: clean
clean:
	$(RMDIRCMD) $(BUILDDIR)

.PHONY: coverage
coverage: $(BUILDDIR)/hypr-dotfiles.eselect
	$(SHELLSPECCMD) --kcov

.PHONY: test
test: $(BUILDDIR)/hypr-dotfiles.eselect
	$(SHELLSPECCMD)

.PHONY: install
install: $(BUILDDIR)/hypr-dotfiles.eselect
	$(INSTALLMKDIRCMD) $(CONFDIR)

	$(INSTALLFILECMD) \
		$(BUILDDIR)/hypr-dotfiles.eselect \
		$(ESELECTDIR)/hypr-dotfiles.eselect
