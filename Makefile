.PHONY: certs clean s_client-3.7 s_client-3.10

certs:
	$(MAKE) -C $(CURDIR)/tls-gen/basic CN=localhost
	cp -vf $(CURDIR)/tls-gen/basic/result/* $(CURDIR)/certs

clean:
	rm -vf rabbitmq_server-3.*/var/log/rabbitmq/*.log
	rm -rf rabbitmq_server-3.*/var/lib/rabbitmq/mnesia/rabbit*

s_client-3.7:
	openssl s_client -connect localhost:5681 -CAfile $(CURDIR)/certs/ca_certificate.pem -cert $(CURDIR)/certs/client_localhost_certificate.pem -key $(CURDIR)/certs/client_localhost_key.pem -verify_hostname 'localhost' -verify_depth 8

s_client-3.10:
	openssl s_client -connect localhost:5671 -CAfile $(CURDIR)/certs/ca_certificate.pem -cert $(CURDIR)/certs/client_localhost_certificate.pem -key $(CURDIR)/certs/client_localhost_key.pem -verify_hostname 'localhost' -verify_depth 8
