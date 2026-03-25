.PHONY: init plan apply destroy encrypt_vault decrypt_vault

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply -auto-approve

destroy:
	cd terraform && terraform destroy -auto-approve

vault-encrypt:
	wsl ansible-vault encrypt ansible/group_vars/all/vault.yml --vault-password-file ansible/.vault_password

vault-decrypt:
	wsl ansible-vault decrypt ansible/group_vars/all/vault.yml --vault-password-file ansible/.vault_password
