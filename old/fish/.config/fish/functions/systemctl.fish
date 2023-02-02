function systemctl
    if contains -- --user $argv
        /usr/bin/systemctl $argv
    else
        /usr/bin/sudo /usr/bin/systemctl $argv
    end
end
