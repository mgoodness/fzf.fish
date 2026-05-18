set --global captured_first_line
function fzf
    read -l line
    set --global captured_first_line $line
    # drain remaining input so the pipeline doesn't stall
    while read -l; end
end

mock commandline --current-token "echo ''"
mock commandline \* ""
mock zoxide "query --list" "printf '/mock_zoxide_dir\n'"

_fzf_search_directory

@test "zoxide results appear before fd results" "$captured_first_line" = /mock_zoxide_dir
