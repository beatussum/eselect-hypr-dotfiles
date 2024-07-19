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

	Describe "for symlink management"
		Describe '`remove_symlinks()`'
			BeforeEach setup_set_unmanaged
			AfterEach cleanup_set

			Describe "with default mode"
				result() {
					@cat <<- EOF
					\`${HOME}/foo.conf\` does not seems to be managed by \`eselect hypr-dotfiles\`.
					Please, refer to \`eselect hypr-dotfiles help\`, and set \`--force\` or \`--skip\`.
					\`${HOME}/foo.conf\` conflicts with the current configuration.
					EOF
				}

				It
					When run remove_symlinks default
					The error should eq "$(result)"
					The status should be failure

					The variable foo_conf should be file
					The variable hypr_dir should be symlink
				End
			End

			It "with force mode"
				When call remove_symlinks force
				The status should be success

				The variable foo_conf should not be exist
				The variable hypr_dir should not be exist
			End

			It "with skip mode"
				When call remove_symlinks skip
				The status should be success

				The variable foo_conf should be file
				The variable hypr_dir should not be exist
			End
		End

		Describe '`set_symlinks()`'
			After cleanup_set

			It
				When call set_symlinks foo

				The value "${SYS_CONF_DIR}/foo.conf.d" should be symlink
				The value "${SYS_CONF_DIR}/foo.conf" should be symlink

				The value "${HOME}/foo.conf.d" should be symlink
				The variable hypr_dir should be symlink
				The variable foo_conf should be symlink
			End
		End
	End
End
