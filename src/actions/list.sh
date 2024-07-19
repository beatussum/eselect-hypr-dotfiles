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


describe_list() {
	echo "List availabe Hyprland configurations"
}

do_list() {
	local current="$(get_current_target)"
	local targets=( $(find_targets) )

	if is_number "${current}"; then
		targets[current]="$(highlight_marker "${targets[current]}")"
	fi

	write_list_start "Available Hyprland configurations:"
	write_numbered_list -m "(none found)" "${targets[@]}"
}
