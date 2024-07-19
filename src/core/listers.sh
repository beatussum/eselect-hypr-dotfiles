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


list_content() {
	local dirs=( "$@" )

	local ret=()

	for dir in "${dirs[@]}"; do
		for entry in "${dir}"/*; do
			[[ -e "${entry}" ]] && ret+=( "${entry}" )
		done
	done

	echo "${ret[@]}"
}

list_directories() {
	local dirs=( "$@" )

	local ret=()

	for dir in "${dirs[@]}"; do
		for entry in "${dir}"/*; do
			[[ -d "${entry}" ]] && ret+=( "${entry}" )
		done
	done

	echo "${ret[@]}"
}
