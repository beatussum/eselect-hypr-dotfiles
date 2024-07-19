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


get_user_item() {
	local item="$1"

	local item_base="${item#*/}"
	local user_item

	case "${item}" in
		etc/*)
			user_item="${SYS_CONF_DIR}/${item_base}"

			;;
		home/*)
			user_item="${HOME}/${item_base}"

			;;
	esac

	echo "${user_item}"
}

get_sys_item() {
	local item="$1"
	local target="$2"

	echo "${CONF_DIR}/${target}/${item}"
}

is_set_to() {
	local item="$1"
	local target="$2"

	local user_item="$(get_user_item "${item}")"
	local sys_item="$(get_sys_item "${item}" "${target}")"

	[[ -L "${user_item}" ]] && \
		[[ "$(realpath "${user_item}")" = "${sys_item}" ]]
}
