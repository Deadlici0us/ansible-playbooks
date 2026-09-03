# Variables
USERNAME = deadlicious
TIME_ZONE = America/Argentina/Buenos_Aires
IMAGE_NAME = portfolio-ansible
SSH_KEY_PUB = ~/.ssh/id_ed25519.pub

.PHONY: build deploy bootstrap

build:
	docker build -t $(IMAGE_NAME) ./docker

# Standard deployment (runs as your custom user on custom port)
setup_vps:
	docker run --rm -it \
		-v $(shell pwd)/ansible:/ansible \
		-v $(SSH_KEY_PUB):/root/.ssh/id_ed25519.pub:ro \
		-v $(SSH_AUTH_SOCK):/run/ssh-agent \
		-e SSH_AUTH_SOCK=/run/ssh-agent \
		$(IMAGE_NAME) \
		ansible-playbook -i ./inventory/hosts.ini setup-vps.yml \
		-u $(USERNAME) \
		-e "deploy_user=$(USERNAME) ansible_port=65500 time_zone=$(TIME_ZONE)" \
		--ask-vault-pass

# Initial setup (runs as root on port 22)
bootstrap_vps:
	docker run --rm -it \
		-v $(shell pwd)/ansible:/ansible \
		-v $(SSH_KEY_PUB):/root/.ssh/id_ed25519.pub:ro \
		-v $(SSH_AUTH_SOCK):/run/ssh-agent \
		-e SSH_AUTH_SOCK=/run/ssh-agent \
		$(IMAGE_NAME) \
		ansible-playbook -i ./inventory/hosts.ini bootstrap.yml \
		-u root \
		--ask-pass \
		-e "deploy_user=$(USERNAME) ansible_port=22" \
		--ask-vault-pass
		
# Add this to your existing Makefile
monitor:
	docker run --rm -it \
		-v $(shell pwd)/ansible:/ansible \
		-v $(SSH_KEY_PUB):/root/.ssh/id_ed25519.pub:ro \
		-v $(SSH_AUTH_SOCK):/run/ssh-agent \
		-e SSH_AUTH_SOCK=/run/ssh-agent \
		$(IMAGE_NAME) \
		ansible-playbook -i ./inventory/hosts.ini monitor-vps.yml \
		-u $(USERNAME) \
		-e "ansible_port=65500" \
		--ask-vault-pass
