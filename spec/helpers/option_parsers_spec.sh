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

	############
	# EXAMPLES #
	############

	BeforeAll setup_configs
	AfterAll cleanup_configs

	Describe "for option parsers"
		Describe '`parse_mode()`'
			It "with default mode"
				When run parse_mode
				The output should eq "default"
			End

			It "with force mode (short option)"
				When run parse_mode -f
				The output should eq "force"
			End

			It "with force mode (long option)"
				When run parse_mode --force
				The output should eq "force"
			End

			It "with skip mode (short option)"
				When run parse_mode -s
				The output should eq "skip"
			End

			It "with skip mode (long option)"
				When run parse_mode --skip
				The output should eq "skip"
			End

			It "with bad option (short option)"
				When run parse_mode -a
				The error should eq '`-a` is not a valid option.'
				The status should be failure
			End

			It "with bad option (long option)"
				When run parse_mode --all
				The error should eq '`--all` is not a valid option.'
				The status should be failure
			End

			It "with positional arguments"
				When run parse_mode -f -- -s
				The output should eq "force -s"
			End

			It "without option"
				When run parse_mode foo
				The output should eq "default foo"
			End
		End
	End
End
