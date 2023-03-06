.PHONY: certs
certs:
	$(MAKE) -C $(CURDIR)/tls-gen/basic CN=localhost
	cp -vf $(CURDIR)/tls-gen/basic/result/* $(CURDIR)/certs
