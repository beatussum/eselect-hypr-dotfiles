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


Describe "Test helper function"
	Include "${PWD}/hypr-dotfiles.eselect"
	Include "${SHELLSPEC_HELPERDIR}/mocks.sh"

	############
	# EXAMPLES #
	############

	BeforeAll setup_configs
	AfterAll cleanup_configs

	Describe "for target management"
		It '`find_targets()`'
			When call find_targets
			The output should eq "bar foo"
		End

		Describe '`get_current_target_name()`'
			It "with unset configuration"
				When call get_current_target_name
				The output should be blank
				The status should be failure
			End

			Describe "with set configuration"
				Before setup_set_unmanaged
				After cleanup_set

				It
					When call get_current_target_name
					The output should eq "foo"
					The status should be success
				End
			End
		End

		Describe '`get_current_target()`'
			It "with unset configuration"
				When call get_current_target
				The output should be blank
				The status should be failure
			End

			Describe "with set configuration"
				Before setup_set_unmanaged
				After cleanup_set

				It
					When call get_current_target
					The output should eq 1
					The status should be success
				End
			End
		End

		Describe '`get_target_at()`'
			Parameters
				"bar" 0
				"foo" 1
			End

			It "with \`$1\`"
				When call get_target_at $2
				The output should eq "$1"
			End
		End
	End
End
