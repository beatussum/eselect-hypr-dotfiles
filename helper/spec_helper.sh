# Copyright (C) 2024 Mattéo Rossillol‑‑Laruelle <beatussum@protonmail.com>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.


#########
# HOOKS #
#########

# variables #

EPREFIX="${PWD}/build/fakeroot"
ROOT="/"
EROOT="${ROOT%/}${EPREFIX}/"
HOME="${EROOT}home"

ENV_VARIABLES=(
	EPREFIX
	ROOT
	EROOT
	HOME
)

SYS_CONF_DIR="${EROOT%/}/etc"
USER_CONF_DIR="${HOME}/.config"

DOTFILES_DIR="${EROOT}etc/eselect/hypr-dotfiles/dotfiles"

foo_conf="${USER_CONF_DIR}/foo.conf"
hypr_dir="${USER_CONF_DIR}/hypr"

# `*_base()` #

setup_base() {
	@mkdir -p "${USER_CONF_DIR}"
	@mkdir -p "${DOTFILES_DIR}"
}

cleanup_base() {
	rm -r "${EROOT}"
}

# `*_configs()` #

setup_configs() {
	for config in foo bar; do
		local config_dir="${DOTFILES_DIR}/${config}"

		@mkdir -p "${config_dir}"/{etc,home}

		@mkdir "${config_dir}"/{etc,home}/"${config}.conf.d"
		@touch "${config_dir}"/{etc,home}/"${config}.conf"
		@mkdir "${config_dir}/home/hypr"
	done
}

cleanup_configs() {
	for config in foo bar; do
		rm -r "${DOTFILES_DIR}/${config}"
	done
}

# `*_set_*()` #

setup_set_ln() {
	local target="$1"; shift
	local items=( "$@" )

	for item in "${items[@]}"; do
		local item_name

		case "${item}" in
			etc/*) item_name="${SYS_CONF_DIR}/${item#etc/}" ;;
			home/*) item_name="${USER_CONF_DIR}/${item#home/}" ;;
		esac

		ln -rs "${DOTFILES_DIR}/${target}/${item}" "${item_name}"
	done
}

setup_set_completed() {
	local config="foo"

	setup_set_ln "${config}" {etc,home}/"${config}.conf"{,.d}
	setup_set_ln "${config}" "home/hypr"
}

setup_set_unmanaged() {
	local config="foo"

	setup_set_ln "${config}" "home/hypr"
	@touch "${USER_CONF_DIR}/${config}.conf"
}

cleanup_set() {
	for config in foo bar; do
		rm -f "${USER_CONF_DIR}/${config}.conf"
		rm -fr "${USER_CONF_DIR}/${config}.conf.d"
		rm -fr "${USER_CONF_DIR}/hypr"

		rm -f "${SYS_CONF_DIR}/${config}.conf"
		rm -fr "${SYS_CONF_DIR}/${config}.conf.d"
	done
}

####################
# MODULE FUNCTIONS #
####################

spec_helper_precheck() {
	minimum_version "0.28.1"

	for variable in "${ENV_VARIABLES[@]}"; do
		setenv "${variable}"="${!variable}"
	done
}

spec_helper_loaded() {
	:
}

spec_helper_configure() {
	import "support/link"

	before_all setup_base
	after_all cleanup_base
}
