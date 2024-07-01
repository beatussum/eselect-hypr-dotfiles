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

EROOT="${PWD}/build/fakeroot"
HOME="${EROOT}/home"

USER_CONF_DIR="${HOME}/.config"
DOTFILES_DIR="${EROOT}/etc/eselect/hypr-dotfiles/dotfiles"

foo_conf="${USER_CONF_DIR}/foo.conf"
hypr_dir="${USER_CONF_DIR}/hypr"

setup() {
	@mkdir -p "${HOME}/.config"

	for config in foo bar; do
		local config_dir="${DOTFILES_DIR}/${config}"

		@mkdir -p "${config_dir}"/{etc,home}

		@mkdir "${config_dir}"/{etc,home}/"${config}.conf.d"
		@touch "${config_dir}"/{etc,home}/"${config}.conf"
		@mkdir "${config_dir}/home/hypr"
	done
}

cleanup() {
	rm -r "${EROOT}"
}

setup_selected() {
	@touch "${foo_conf}"
	ln -frs "${DOTFILES_DIR}/foo/home/hypr" "${hypr_dir}"
}

cleanup_selected() {
	rm -f "${foo_conf}"
	rm -f "${hypr_dir}"
}

####################
# MODULE FUNCTIONS #
####################

spec_helper_precheck() {
	minimum_version "0.28.1"

	setenv EROOT="${EROOT}"
	setenv HOME="${HOME}"
}

spec_helper_loaded() {
	:
}

spec_helper_configure() {
	:
}
