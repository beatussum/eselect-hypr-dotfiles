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

	Describe '`help`'
		result() {
			@cat <<- EOF
			Manage Hyprland dotfiles
			Usage: eselect ${PWD}/hypr-dotfiles.eselect <action> <options>

			Standard actions:
			  help                      Display help text
			  usage                     Display usage information
			  version                   Display version information

			Extra actions:
			  list                      List availabe Hyprland dotfiles
			  set <target>              Set a target as the current Hyprland configuration
			    --force                   If an entry of the configuration conflicts with
			                              an entry of the system which is not managed by
			                              \`eselect hypr-dotfiles\`, the latter is replaced
			    --skip                    If an entry of the configuration conflicts with
			                              an entry of the system which is not managed by
			                              \`eselect hypr-dotfiles\`, the latter is kept
			    target                    Target name or number (from \`list\` action)
			  show                      Show the current Hyprland configuration
			  unset                     Unset the current Hyprland configuration
			    --force                   If an entry of the configuration is not a
			                              symbolic link and, therefore, is not managed by
			                              \`eselect hypr-dotfiles\`, it is removed
			    --skip                    If an entry of the configuration is not a
			                              symbolic link and, therefore, is not managed by
			                              \`eselect hypr-dotfiles\`, it is ignored
			EOF
		}

		It
			When run eselect help
			The output should eq "$(result)"
			The status should be success
		End
	End

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
					When run eselect list
					The output should eq "$(result)"
					The status should be success
				End
			End

			Describe "(selected)"
				Before setup_set_completed
				After cleanup_set

				result() {
					%text
					#|Available Hyprland dotfiles:
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

		Describe "with no configuration"
			result() {
				%text
				#|Available Hyprland dotfiles:
				#|  (none found)
			}

			It
				When run eselect list
				The output should eq "$(result)"
				The status should be success
			End
		End
	End

	Describe '`set`'
		BeforeAll setup_configs
		AfterAll cleanup_configs

		Describe "(selected unmanaged)"
			BeforeEach setup_set_unmanaged
			AfterEach cleanup_set

			Describe '(with `--force`)'
				It "(with number)"
					When run eselect set --force 1
					The status should be success
					The variable foo_conf should not be exist
					The variable hypr_dir should link "${DOTFILES_DIR}/bar/home/hypr"
				End

				It "(with name)"
					When run eselect set --force bar
					The status should be success
					The variable foo_conf should not be exist
					The variable hypr_dir should link "${DOTFILES_DIR}/bar/home/hypr"
				End
			End

			Describe '(with `--force`)'
				It "(with number)"
					When run eselect set --skip 1
					The status should be success
					The variable foo_conf should be file
					The variable hypr_dir should link "${DOTFILES_DIR}/bar/home/hypr"
				End

				It "(with name)"
					When run eselect set --skip bar
					The status should be success
					The variable foo_conf should be file
					The variable hypr_dir should link "${DOTFILES_DIR}/bar/home/hypr"
				End
			End
		End

		Describe "(selected)"
			BeforeEach setup_set_completed
			AfterEach cleanup_set

			It "(with number)"
				When run eselect set 1
				The status should be success
				The variable hypr_dir should link "${DOTFILES_DIR}/bar/home/hypr"
			End

			It "(with name)"
				When run eselect set bar
				The status should be success
				The variable hypr_dir should link "${DOTFILES_DIR}/bar/home/hypr"
			End
		End

		Describe "(no selected)"
			AfterEach cleanup_set

			It "(with number)"
				When run eselect set 1
				The status should be success
				The variable hypr_dir should link "${DOTFILES_DIR}/bar/home/hypr"
			End

			It "(with name)"
				When run eselect set bar
				The status should be success
				The variable hypr_dir should link "${DOTFILES_DIR}/bar/home/hypr"
			End
		End
	End

	Describe '`show`'
		BeforeAll setup_configs
		AfterAll cleanup_configs

		Describe "(none selected)"
			result() {
				%text
				#|Current Hyprland configuration:
				#|  (unset)
			}

			It
				When run eselect show
				The output should eq "$(result)"
				The status should be success
			End
		End

		Describe "(selected)"
			Before setup_set_completed
			After cleanup_set

			result() {
				%text
				#|Current Hyprland configuration:
				#|  foo
			}

			It
				When run eselect show
				The output should eq "$(result)"
				The status should be success
			End
		End
	End

	Describe '`unset`'
		BeforeAll setup_configs
		AfterAll cleanup_configs

		Describe "(selected unmanaged)"
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

		Describe "(selected)"
			BeforeEach setup_set_completed
			AfterEach cleanup_set

			It
				When run eselect unset
				The status should be success
				The variable hypr_dir should not be exist
			End
		End

		It "(no selected)"
			When run eselect unset
			The status should be failure
		End
	End
End
