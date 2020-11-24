OC := EFI/OC

$(OC)/config.plist: $(OC)/config.tpl.plist serials.txt
	cp $(OC)/config.tpl.plist $(OC)/config.plist
	for key in MLB SystemSerialNumber SystemUUID; do \
		plutil -replace PlatformInfo.Generic.$${key} -string $$(grep $${key} serials.txt | cut -f2 -d' ') $(OC)/config.plist; \
	done

.PHONY: config
config: $(OC)/config.plist

.PHONY: sync
sync: config
	rsync -av --delete EFI $(TARGET)

.PHONY: clean
clean:
	rm -f $(OC)/config.plist
