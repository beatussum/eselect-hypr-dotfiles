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


shellspec_syntax "shellspec_matcher_link"

shellspec_matcher_link() {
	shellspec_matcher_link_get_subject_link() {
		if [ ! -e "${SHELLSPEC_SUBJECT}" ]; then
			echo "(the origin path does not exist)"

			return 1
		elif [ ! -L "${SHELLSPEC_SUBJECT}" ]; then
			echo "(the origin path is not a symbolic link)"

			return 1
		else
			echo "\"$(realpath "${SHELLSPEC_SUBJECT}")\""

			return 0
		fi
	}

	shellspec_matcher__match() {
		SHELLSPEC_EXPECT="$1"

		local link

		link="$(shellspec_matcher_link_get_subject_link)" && \
			[ "${link}" = "\"${SHELLSPEC_EXPECT}\"" ]
	}
	
	shellspec_matcher__match_when_negated() {
		SHELLSPEC_EXPECT="$1"

		local link

		link="$(shellspec_matcher_link_get_subject_link)" && \
			[ "${link}" != "\"${SHELLSPEC_EXPECT}\"" ]
	}

	shellspec_syntax_failure_message \
		+ \
		'The specified path is not linked to the appropriate target' \
		'origin:   $1' \
		'expected: $2' \
		'got:      $(shellspec_matcher_link_get_subject_link)'

	shellspec_syntax_failure_message \
		- \
		'The specified path is not linked to the appropriate target' \
		'origin:       $1' \
		'not expected: $2' \
		'got:          $(shellspec_matcher_link_get_subject_link)'

	shellspec_syntax_param count [ $# -eq 1 ] || return 0
	shellspec_matcher_do_match "$@"
}
