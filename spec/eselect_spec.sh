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


Describe 'Test `eselect` subcommand'
	has_not_eselect() {
		! @eselect &>> /dev/null
	}

	Skip if '`eselect` cannot be found' has_not_eselect

	############
	# WRAPPERS #
	############

	eselect() {
		@eselect \
			--colour=no \
			--eprefix="${EPREFIX}" \
			"${PWD}/hypr-dotfiles.eselect" \
			"$@"
	}

	############
	# EXAMPLES #
	############

	Describe '`list`'
		Describe "with configurations"
			BeforeAll setup_configs
			AfterAll cleanup_configs

			Describe "(none selected)"
				result() {
					%text
					#|Available Hyprland dotfiles:
					#|  [1]   bar
					#|  [2]   foo
				}

				It
					When call eselect list
					The output should eq "$(result)"
					The status should be success
				End
			End

			Describe "(selected)"
				Before setup_selected
				After cleanup_selected

				result() {
					%text
					#|Available Hyprland dotfiles:
					#|  [1]   bar
					#|  [2]   foo *
				}

				It
					When call eselect list
					The output should eq "$(result)"
					The status should be success
				End
			End
		End

		Describe "with no configuration"
			result() {
				%text
				#|Available Hyprland dotfiles:
				#|  (none found)
			}

			It
				When call eselect list
				The output should eq "$(result)"
				The status should be success
			End
		End
	End
End
