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


parse_mode() {
	local mode=default

	while [[ $# -ne 0 ]]; do
		case "$1" in
			--force|-f) mode=force ;;
			--skip|-s) mode=skip ;;

			--)
				shift
				break

				;;

			-*) die -q "\`$1\` is not a valid option." ;;
			*) break ;;
		esac

		shift
	done

	echo "${mode}" "$@"
}
