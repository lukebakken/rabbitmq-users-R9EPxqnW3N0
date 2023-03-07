.PHONY: certs clean

certs:
	$(MAKE) -C $(CURDIR)/tls-gen/basic CN=localhost
	cp -vf $(CURDIR)/tls-gen/basic/result/* $(CURDIR)/certs

clean:
	rm -vf rabbitmq_server-3.*/var/log/rabbitmq/*.log
	rm -rf rabbitmq_server-3.*/var/lib/rabbitmq/mnesia/rabbit*
