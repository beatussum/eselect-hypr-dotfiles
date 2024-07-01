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

	#########
	# HOOKS #
	#########

	foo_conf="${USER_CONF_DIR}/foo.conf"
	hypr_dir="${USER_CONF_DIR}/hypr"

	setup() {
		@mkdir -p "${HOME}/.config"

		for config in foo bar; do
			local config_dir="${DOTFILES_DIR}/${config}"

			@mkdir -p "${config_dir}"/{etc,home}

			@mkdir "${config_dir}"/{etc,home}/"${config}.conf.d"
			@touch "${config_dir}"/{etc,home}/"${config}.conf"
			@mkdir "${config_dir}/home/hypr"
		done
	}

	cleanup() {
		rm -r "${EROOT}"
	}

	setup_selected() {
		@touch "${foo_conf}"
		ln -frs "${DOTFILES_DIR}/foo/home/hypr" "${hypr_dir}"
	}

	cleanup_selected() {
		rm -f "${foo_conf}"
		rm -f "${hypr_dir}"
	}

	#########
	# MOCKS #
	#########

	die() {
		while [[ $1 == -* ]]; do
			shift
		done

		local msg="$*"

		echo "${msg}" >&2
		exit 1
	}

	write_error_msg() {
		local msg="$*"

		echo "${msg}" >&2
	}

	############
	# EXAMPLES #
	############

	BeforeAll setup
	AfterAll cleanup

	Describe "for option parsers"
		Describe '`parse_mode()`'
			preserve() {
				%preserve mode
			}

			AfterRun preserve

			It "with default mode"
				When run parse_mode
				The variable mode should eq "default"
			End

			It "with force mode (short option)"
				When run parse_mode -f
				The variable mode should eq "force"
			End

			It "with force mode (long option)"
				When run parse_mode --force
				The variable mode should eq "force"
			End

			It "with skip mode (short option)"
				When run parse_mode -s
				The variable mode should eq "skip"
			End

			It "with skip mode (long option)"
				When run parse_mode --skip
				The variable mode should eq "skip"
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
		End
	End

	Describe "for item management"
		Describe '`get_user_item()`'
			It 'with `etc` item'
				When call get_user_item etc/foo.conf
				The output should eq "${SYS_CONF_DIR}/foo.conf"
			End

			It 'with `home` item'
				When call get_user_item home/foo.conf
				The output should eq "${USER_CONF_DIR}/foo.conf"
			End
		End

		Describe '`get_sys_item()`'
			It "with normal input"
				When call get_sys_item home/foo.conf foo
				The output should eq "${DOTFILES_DIR}/foo/home/foo.conf"
			End
		End

		Describe '`is_set_to()`'
			BeforeAll setup_selected
			AfterAll cleanup_selected

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

	Describe "for symlink management"
		Describe '`remove_symlinks()`'
			BeforeEach setup_selected
			AfterEach cleanup_selected

			It "with default mode"
				When run remove_symlinks default
				The error should eq ""
				The status should be failure

				The variable foo_conf should be file
				The variable hypr_dir should be symlink
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
			cleanup_selected() {
				rm "${SYS_CONF_DIR}/foo.conf.d"
				rm "${SYS_CONF_DIR}/foo.conf"

				rm "${USER_CONF_DIR}/foo.conf.d"
				rm "${hypr_dir}"
				rm "${foo_conf}"
			}

			After cleanup_selected

			It
				When call set_symlinks foo

				The value "${SYS_CONF_DIR}/foo.conf.d" should be symlink
				The value "${SYS_CONF_DIR}/foo.conf" should be symlink

				The value "${USER_CONF_DIR}/foo.conf.d" should be symlink
				The variable hypr_dir should be symlink
				The variable foo_conf should be symlink
			End
		End
	End

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
				Before setup_selected
				After cleanup_selected

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
				Before setup_selected
				After cleanup_selected

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
