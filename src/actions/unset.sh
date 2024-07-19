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


describe_unset() {
	echo "Unset the current Hyprland configuration"
}

describe_unset_options() {
	echo '--force : If an entry of the configuration is not a symbolic link and, therefore, is not managed by `eselect hypr-dotfiles`, it is removed'
	echo '--skip  : If an entry of the configuration is not a symbolic link and, therefore, is not managed by `eselect hypr-dotfiles`, it is ignored'
}

do_unset() {
	set -- $(parse_mode "$@")

	local mode="$1"

	get_current_target &>> /dev/null && remove_symlinks "${mode}"
}
