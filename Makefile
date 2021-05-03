NAME = service.lt2http
GIT = git
GIT_VERSION = $(shell $(GIT) describe --always)
GIT_USER = ElementumOrg
GIT_REPOSITORY = service.lt2http
VERSION = $(shell sed -ne "s/.*version=\"\([0-9a-z\.\-]*\)\"\sprovider.*/\1/p" addon.xml)
ZIP_SUFFIX = zip
ZIP_FILE = $(NAME)-$(VERSION).$(ZIP_SUFFIX)

all: clean zip

.PHONY: zip

# $(ARCHS):
# 	$(MAKE) clean_arch ZIP_SUFFIX=$@.zip
# 	$(MAKE) zip ARCHS=$@ ZIP_SUFFIX=$@.zip

$(ZIP_FILE):
	git archive --format zip --prefix $(NAME)/ --output $(ZIP_FILE) HEAD
	# mkdir -p $(NAME)/resources/bin
	# for arch in $(ARCHS); do \
	# 	cp -r `pwd`/$(DEV)/resources/bin/$$arch $(NAME)/resources/bin/$$arch; \
	# 	zip -9 -r -g $(ZIP_FILE) $(NAME)/resources/bin/$$arch; \
	# done
	# rm -rf $(NAME)

zip: $(ZIP_FILE)

# zipfiles: addon.xml
# 	for arch in $(ARCHS); do \
# 		$(MAKE) $$arch; \
# 	done

upload:
	$(eval EXISTS := $(shell github-release info --user $(GIT_USER) --repo $(GIT_REPOSITORY) --tag v$(VERSION) 1>&2 2>/dev/null; echo $$?))
ifneq ($(EXISTS),1)
	github-release release \
		--user $(GIT_USER) \
		--repo $(GIT_REPOSITORY) \
		--tag v$(VERSION) \
		--name "$(VERSION)" \
		--description "$(VERSION)"
endif

	github-release upload \
		--user $(GIT_USER) \
		--repo $(GIT_REPOSITORY) \
		--replace \
		--tag v$(VERSION) \
		--file $(NAME)-$(VERSION).zip \
		--name $(NAME)-$(VERSION).zip

clean:
	rm -f $(ZIP_FILE)
	rm -rf $(NAME)

binaries:
	rm -rf service.lt2http
	wget https://github.com/ElementumOrg/lt2http-binaries/archive/master.zip && \
	unzip master.zip && \
	mv lt2http-binaries-master/* resources/bin/ && \
	rm -rf lt2http-binaries-master && \
	rm master.zip
