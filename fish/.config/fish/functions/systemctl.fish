function systemctl
    if contains -- --user $argv
            /usr/bin/systemctl $argv
    end
    /usr/bin/sudo /usr/bin/systemctl $argv
end
