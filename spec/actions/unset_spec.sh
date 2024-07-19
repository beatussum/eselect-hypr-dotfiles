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

	Describe '`unset`'
		BeforeAll setup_configs
		AfterAll cleanup_configs

		It "without set"
			When run eselect unset
			The status should be failure
		End

		Describe "with set and completed"
			BeforeEach setup_set_completed
			AfterEach cleanup_set

			It
				When run eselect unset
				The status should be success
				The variable hypr_dir should not be exist
			End
		End

		Describe "with set and unmanaged"
			BeforeEach setup_set_unmanaged
			AfterEach cleanup_set

			It '(with `--force`)'
				When run eselect unset --force
				The status should be success
				The variable foo_conf should not be exist
				The variable hypr_dir should not be exist
			End

			It '(with `--skip`)'
				When run eselect unset --skip
				The status should be success
				The variable foo_conf should be file
				The variable hypr_dir should not be exist
			End
		End
	End
End
