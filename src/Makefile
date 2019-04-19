all: ../local/bin/metwork_repos.py ../local/bin/metwork_valid_merge_logic_status.py ../local/bin/_generate_changelog.sh ../local/bin/changelogs.sh

../local/bin/metwork_repos.py:
	mkdir -p ../local/bin
	wget -O $@ "https://raw.githubusercontent.com/metwork-framework/resources/master/scripts/metwork_repos.py"
	chmod +x $@

../local/bin/_generate_changelog.sh: _generate_changelog.sh
	mkdir -p ../local/bin
	cp -f $< $@
	chmod +x $@

../local/bin/changelogs.sh: changelogs.sh
	mkdir -p ../local/bin
	cp -f $< $@
	chmod +x $@

../local/bin/metwork_valid_merge_logic_status.py:
	mkdir -p ../local/bin
	wget -O $@ "https://raw.githubusercontent.com/metwork-framework/resources/master/scripts/metwork_valid_merge_logic_status.py"
	chmod +x $@
