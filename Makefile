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
JOINCMD			?= contrib/join
RMDIRCMD		?= rm -fr
SEDCMD			?= sed
SHELLSPECCMD	?= shellspec

.PHONY: all
all: $(BUILDDIR)/hypr-dotfiles.eselect

$(BUILDDIR):
	$(INSTALLMKDIRCMD) $@

$(BUILDDIR)/hypr-dotfiles.eselect: src/hypr-dotfiles.eselect.in $(BUILDDIR)
	$(JOINCMD) \
		VERSION='"$(VERSION)"' \
		DIRECTORIES=src/directories.sh \
		CORE=src/core \
		HELPERS=src/helpers \
		ACTIONS=src/actions \
		$< > $@

$(BUILDDIR)/test-hypr-dotfiles.eselect: src/hypr-dotfiles.eselect.in $(BUILDDIR)
	$(JOINCMD) \
		VERSION='"$(VERSION)"' \
		DIRECTORIES=helper/include/directories.sh \
		CORE=helper/include/core.sh \
		HELPERS=helper/include/helpers.sh \
		ACTIONS=helper/include/actions.sh \
		$< > $@

.PHONY: clean
clean:
	$(RMDIRCMD) $(BUILDDIR)

.PHONY: coverage
coverage: $(BUILDDIR)/test-hypr-dotfiles.eselect
	$(SHELLSPECCMD) --kcov

.PHONY: test
test: $(BUILDDIR)/test-hypr-dotfiles.eselect
	$(SHELLSPECCMD)

.PHONY: install
install: $(BUILDDIR)/hypr-dotfiles.eselect
	$(INSTALLMKDIRCMD) $(CONFDIR)

	$(INSTALLFILECMD) \
		$(BUILDDIR)/hypr-dotfiles.eselect \
		$(ESELECTDIR)/hypr-dotfiles.eselect
