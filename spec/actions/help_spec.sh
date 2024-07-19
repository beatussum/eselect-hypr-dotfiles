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
			  list                      List availabe Hyprland configurations
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
End
