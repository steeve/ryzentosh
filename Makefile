OC=EFI/OC

$(OC)/config.plist: $(OC)/config.tpl.plist serials.txt
	cp $(OC)/config.tpl.plist $(OC)/config.plist
	for key in MLB SystemSerialNumber SystemUUID; do \
		plutil -replace PlatformInfo.Generic.$${key} -string $$(grep $${key} serials.txt | cut -f2 -d' ') $(OC)/config.plist; \
	done

.PHONY: sync
sync: $(OC)/config.plist
	rsync -av --delete EFI $(TARGET)
