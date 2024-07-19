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
	Include "${SHELLSPEC_HELPERDIR}/mocks.sh"
	Include "${SHELLSPEC_PROJECT_ROOT}/src/helpers/item.sh"

	############
	# EXAMPLES #
	############

	BeforeAll setup_configs
	AfterAll cleanup_configs

	Describe "for item management"
		Describe '`get_user_item()`'
			It 'with `etc` item'
				When call get_user_item etc/foo.conf
				The output should eq "${SYS_CONF_DIR}/foo.conf"
			End

			It 'with `home` item'
				When call get_user_item home/foo.conf
				The output should eq "${HOME}/foo.conf"
			End
		End

		Describe '`get_sys_item()`'
			It "with normal input"
				When call get_sys_item home/foo.conf foo
				The output should eq "${CONF_DIR}/foo/home/foo.conf"
			End
		End

		Describe '`is_set_to()`'
			BeforeAll setup_set_unmanaged
			AfterAll cleanup_set

			It "with symlink"
				When call is_set_to home/hypr foo
				The status should be success
			End

			It "with bad symlink"
				When call is_set_to home/hypr bar
				The status should be failure
			End

			It "with no symlink"
				When call is_set_to home/foo.conf foo
				The status should be failure
			End
		End
	End
End
