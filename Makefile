COMPOSE = docker compose
RUN = $(COMPOSE) exec -T control ./almighty.sh

.PHONY: demo demo-up demo-check demo-down

## demo: start the demo machines and run init, set and push against them
demo: demo-up
	$(RUN) init
	$(RUN) set
	$(RUN) push
	@$(MAKE) --no-print-directory demo-check

demo/.keys/id_ed25519:
	mkdir -p demo/.keys
	ssh-keygen -t ed25519 -N '' -C omnipresent-demo -f $@

## demo-up: build and start the control host and two nodes
demo-up: demo/.keys/id_ed25519
	$(COMPOSE) up -d --build

## demo-check: confirm each server answers with the PHP page
demo-check:
	@for port in 8080 8081 8082; do \
		printf 'localhost:%s -> ' $$port; \
		curl -fsS http://localhost:$$port || exit 1; \
	done

## demo-down: stop and remove the demo machines
demo-down:
	$(COMPOSE) down
