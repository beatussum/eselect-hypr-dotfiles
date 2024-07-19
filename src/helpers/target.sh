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


find_targets() {
	local targets=()

	for conf in $(list_directories "${CONF_DIR}"); do
		targets+=( "$(basename "${conf}")" )
	done

	echo "${targets[@]}"
}

get_current_target_name() {
	local hypr_dir="${HOME}/hypr"

	if [[ -L "${hypr_dir}" ]]; then
		local target_dir="$(realpath "${hypr_dir}/../..")"
		local current_name="$(basename "${target_dir}")"

		if is_set_to "home/hypr" "${current_name}"; then
			echo "${current_name}"
			return 0
		fi
	fi

	return 1
}

get_current_target() {
	local current_name

	if current_name="$(get_current_target_name)"; then
		local targets=( $(find_targets) )

		for (( i = 0; i != ${#targets[@]}; ++i )); do
			if [[ "${targets[i]}" = "${current_name}" ]]; then
				echo $i
				return 0
			fi
		done
	else
		return 1
	fi
}

get_target_at() {
	local n=$1

	local targets=( $(find_targets) )

	echo "${targets[n]}"
}
