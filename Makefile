.PHONY: all
all: Solutions/Tanium/Packages/1.0.0.zip

Solutions/Tanium/Packages/1.0.0.zip: Tools/Create-Azure-Sentinel-Solution/input/Solution_Tanium.json
	./tanium_scripts/pre-build.sh && \
	./tanium_scripts/fix_playbooks.sh && \
	./tanium_scripts/build.sh

.PHONY: dev-server
dev-server:
	cd ./Solutions/Tanium && python3 -m http.server
