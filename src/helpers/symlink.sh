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


remove_symlinks() {
	local mode="$1"

	local current="$(get_current_target_name)"
	local conf_dir="${CONF_DIR}/${current}"

	local to_remove=()

	for item in $(list_content "${conf_dir}"/{etc,home}); do
		local item_base="${item#"${conf_dir}/"}"
		local user_item="$(get_user_item "${item_base}")"

		if [[ -e "${user_item}" ]]; then
			case "${mode}" in
				default)
					if is_set_to "${item_base}" "${current}"; then
						to_remove+=( "${user_item}" )
					else
						write_error_msg "\`${user_item}\` does not seems to be managed by \`eselect hypr-dotfiles\`."
						write_error_msg 'Please, refer to `eselect hypr-dotfiles help`, and set `--force` or `--skip`.'
						die -q "\`${user_item}\` conflicts with the current configuration."
					fi

					;;

				force)
					[[ -e "${user_item}" ]] \
						&& to_remove+=( "${user_item}" )

					;;

				skip)
					is_set_to "${item_base}" "${current}" \
						&& to_remove+=( "${user_item}" )

					;;
			esac
		fi
	done

	if [[ ${#to_remove[@]} -ne 0 ]]; then
		rm "${to_remove[@]}" || die -q
	fi
}

set_symlinks() {
	local target="$1"

	local conf_dir="${CONF_DIR}/${target}"

	for item in $(list_content "${conf_dir}"/{etc,home}); do
		local item_base="${item#"${conf_dir}/"}"

		ln -rs \
			"$(get_sys_item "${item_base}" "${target}")" \
			"$(get_user_item "${item_base}")" \
			|| die -q
	done
}
