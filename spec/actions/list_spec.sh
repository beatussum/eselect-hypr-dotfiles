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
	Skip if '`eselect` cannot be found' has_not_eselect

	Describe '`list`'
		Describe "without configuration"
			result() {
				%text
				#|Available Hyprland configurations:
				#|  (none found)
			}

			It
				When run eselect list
				The output should eq "$(result)"
				The status should be success
			End
		End

		Describe "with configurations"
			BeforeAll setup_configs
			AfterAll cleanup_configs

			Describe "without set"
				result() {
					%text
					#|Available Hyprland configurations:
					#|  [1]   bar
					#|  [2]   foo
				}

				It
					When run eselect list
					The output should eq "$(result)"
					The status should be success
				End
			End

			Describe "with set"
				Before setup_set_completed
				After cleanup_set

				result() {
					%text
					#|Available Hyprland configurations:
					#|  [1]   bar
					#|  [2]   foo *
				}

				It
					When run eselect list
					The output should eq "$(result)"
					The status should be success
				End
			End
		End
	End
End
