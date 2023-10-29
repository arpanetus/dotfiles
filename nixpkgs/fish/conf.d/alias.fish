# all the aliases must be listed here


# poetry shell is a buggy mess. this is a workaround to reactivate shell, 
# since the nix-env.fish resets the python command to the default nix one
function acpoet
  set cur_poetry_path (poetry env info --path)
  source $cur_poetry_path/bin/activate.fish
end 
