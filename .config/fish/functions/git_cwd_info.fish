function git_cwd_info
	if test -d .git
		echo -e ":"(git_parse_branch)"\033[0m@\033[90m"(git_head_commit_id)
		if not test (git ls-files -m | wc -l) -eq 0
			echo "+"
		end
	end


end
