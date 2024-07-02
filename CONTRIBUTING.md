# Contributing to `eselect-hypr-dotfiles`

## Table of contents

[Style guides](#style-guides)
  - [Git branch strategy](#git-branch-strategy)
  - [Git commit messages](#git-commit-messages)

  - [Coding style guide](#coding-style-guide)
    - [Indentation](#indentation)
    - [ShellSpec](#shellspec)

## Style guides

### Git branch strategy

The Branch Strategy is based on [git-flow-lite](http://nvie.com/posts/a-successful-git-branching-model/).

- **develop**: points to the development of the next release, contains tested and reviewed code.
- **feature/_<name>_**: points to a branch with a new feature, one which is candidate for merge into develop (subject to rebase).
- **fix/_<name>_**: points to a branch with a fix for a particular issue ID.

**Note:** The **latest** tag is used to point to the most recent stable release.

### Git commit messages

- Use the present tense ("add feature" not "added feature").
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...").
- Limit the first line to 80 characters or less.
- Reference issues and pull requests liberally.
- If your pull request fixes an existing issue, add "Fixes: _<ISSUEURL>_" to your pull request description.

### Coding style guide

- All bash files in this project must use [snake case](https://en.wikipedia.org/wiki/Snake_case).
- Constants should be uppercase.
- Functions should not be defined with the `function` keyword.

- Section of code should be delimited with:

    ```bash
    ###########
    # SECTION #
    ###########
    ```

- Subection of code should be delimited with:

    ```bash
    # subsection #
    ```

#### Indentation

- For **Bash files** (`src/*`): 1 tabulation
- For **Makefile files**: 1 tabulation
- For **Markdown files** (`*.md`): 4 spaces
- For **`shellspec` files** (`spec/*_spec.sh`): 1 tabulation

#### ShellSpec

In this project, testing is provided by [ShellSpec](https://shellspec.info/).

First, it is recommended to consult the [`README.md`](https://github.com/shellspec/shellspec/blob/master/README.md) file and [the references](https://github.com/shellspec/shellspec/blob/master/docs/references.md) in order to create suitable tests.

The helper directory is at `helper/` and tests are in `spec/`.

ShellSpec uses `--sandbox`; for this reason, if an external command is needed, a support command should be created.
If this command is only used in a `spec/*_spec.sh` file, the associated support command name should be prefixed by _@_.

Respect code hiearchy by using `Describe` in order to group correctly the different _examples_.

The following aliases should be preferred:
- `*Describe`
- `*It`
- `BeforeEach`
- `AfterEach`

For group containing only one anonymous example, `Before` and `After` should be used.

```
Describe "Test helper function"
	Describe "for target management"
		Describe '`get_current_target()`'
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
    End
End
```

The concatenation of a group hiearchy should form sentence.
In the above example, one get _Test helper function for target management `get_current_target()` with set configuration_.
