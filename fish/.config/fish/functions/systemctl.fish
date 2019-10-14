function systemctl
	for option in $argv
        if [ "$option" = "--user" ]
            exec /usr/bin/systemctl $argv
        end
    end
    exec sudo /usr/bin/systemctl $argv
end
