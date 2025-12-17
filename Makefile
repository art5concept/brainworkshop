PREFIX ?= /usr
DESTDIR ?= 
OPTDIR = /opt/brainworkshop

install:
	# Create directories
	install -d $(DESTDIR)$(OPTDIR)
	install -d $(DESTDIR)$(PREFIX)/bin
	install -d $(DESTDIR)$(PREFIX)/share/applications
	install -d $(DESTDIR)$(PREFIX)/share/icons/hicolor/48x48/apps
	
	# Copy application files
	cp -r res data brainworkshop.pyw Readme.txt $(DESTDIR)$(OPTDIR)/
	
	# Install wrapper script
	install -m 755 brainworkshop_wrapper.sh $(DESTDIR)$(PREFIX)/bin/brainworkshop
	
	# Install desktop file
	install -m 644 brainworkshop.desktop $(DESTDIR)$(PREFIX)/share/applications/
	
	# Install icon
	install -m 644 res/misc/brain/brain.png $(DESTDIR)$(PREFIX)/share/icons/hicolor/48x48/apps/brainworkshop.png

uninstall:
	rm -rf $(DESTDIR)$(OPTDIR)
	rm -f $(DESTDIR)$(PREFIX)/bin/brainworkshop
	rm -f $(DESTDIR)$(PREFIX)/share/applications/brainworkshop.desktop
	rm -f $(DESTDIR)$(PREFIX)/share/icons/hicolor/48x48/apps/brainworkshop.png
