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

	Describe '`set`'
		BeforeAll setup_configs
		AfterAll cleanup_configs

		Describe "with set and completed"
			BeforeEach setup_set_completed
			AfterEach cleanup_set

			It "with name"
				When run eselect set bar
				The status should be success
				The variable hypr_dir should link "${CONF_DIR}/bar/home/hypr"
			End

			It "with number"
				When run eselect set 1
				The status should be success
				The variable hypr_dir should link "${CONF_DIR}/bar/home/hypr"
			End
		End

		Describe "with set and unmanaged"
			BeforeEach setup_set_unmanaged
			AfterEach cleanup_set

			Describe 'with `--force`'
				It "with name"
					When run eselect set --force bar
					The status should be success
					The variable foo_conf should not be exist
					The variable hypr_dir should link "${CONF_DIR}/bar/home/hypr"
				End

				It "with number"
					When run eselect set --force 1
					The status should be success
					The variable foo_conf should not be exist
					The variable hypr_dir should link "${CONF_DIR}/bar/home/hypr"
				End
			End

			Describe 'with `--force`'
				It "with name"
					When run eselect set --skip bar
					The status should be success
					The variable foo_conf should be file
					The variable hypr_dir should link "${CONF_DIR}/bar/home/hypr"
				End

				It "with number"
					When run eselect set --skip 1
					The status should be success
					The variable foo_conf should be file
					The variable hypr_dir should link "${CONF_DIR}/bar/home/hypr"
				End
			End
		End

		Describe "without set"
			AfterEach cleanup_set

			It "with name"
				When run eselect set bar
				The status should be success
				The variable hypr_dir should link "${CONF_DIR}/bar/home/hypr"
			End

			It "with number"
				When run eselect set 1
				The status should be success
				The variable hypr_dir should link "${CONF_DIR}/bar/home/hypr"
			End
		End
	End
End
