# ansible

## CLI

* ansible
* ansible-playbook
* ansible-vault
* ansible-galaxy
* ansible-console
* ansible-config
* ansible-doc
* ansible-inventory
* ansible-pull

```sh
ansible <host-pattern> \
    -M `MODULE_PATH` --module-path=`MODULE_PATH`
    -m `MODULE_NAME=command` --module-name=`MODULE_NAME=command`
    -a `MODULE_ARGS` --args=`MODULE_ARGS`
    -e `EXTRA_VARS` --extra-vars=`EXTRA_VARS`
    -i `INVENTORY` --inventory=`INVENTORY`
    -f `FORKS=5` --fork=`FORKS=5`
    -l `SUBSET` --limit=`SUBSET`
    -t `TREE` --tree=`TREE`
    --new-vault-id=`NEW_VAULT_ID`
    --new-vault-password-file=`NEW_VAULT_PASSWORD_FILES`
    --vault-id=`VAULT_IDS`
    --vault-password-file=`VAULT_PASSWORD_FILES`
    --ask-vault-pass
    -o --one-line
    -v --verbose
    -C --check
    -D --diff
    --version
    --syntax-check

    -k --ask-pass
    --private-key=`PRIVATE_KEY_FILE` --key-file=`PRIVATE_KEY_FILE`
    -u `REMOTE_USER=root` --user=`REMOTE_USER=root`
    -c `CONNECTION=smart` --connection=`CONNECTION=smart`
    -T `TIMEOUT=10s` --timeout=`TIMEOUT=10s`
    --ssh-common-args=`SSH_COMMON_ARGS`
    --sftp-extra-args=`SFTP_EXTRA_ARGS`
    --scp-extra-args=`SCP_EXTRA_ARGS`
    --ssh-extra-args=`SSH_EXTRA_ARGS`

    -b --become
    -K --ask-become-pass
    --become-method=`BECOME_METHOD=sudo`
    --become-user=`BECOME_USER=root`
```

```sh
ansible-playbook \
    -M `MODULE_PATH` --module-path=`MODULE_PATH`
    # -m `MODULE_NAME` --module-name=`MODULE_NAME`
    # -a `MODULE_ARGS` --args=`MODULE_ARGS`
    -e `EXTRA_VARS` --extra-vars=`EXTRA_VARS`
    -i `INVENTORY` --inventory=`INVENTORY`
    -f `FORKS=5` --fork=`FORKS=5`
    -l `SUBSET` --limit=`SUBSET`
    # -t `TREE` --tree=`TREE`
    --new-vault-id=`NEW_VAULT_ID`
    --new-vault-password-file=`NEW_VAULT_PASSWORD_FILES`
    --vault-id=`VAULT_IDS`
    --vault-password-file=`VAULT_PASSWORD_FILES`
    --ask-vault-pass
    -o --one-line
    -v --verbose
    -C --check
    -D --diff
    --version
    --syntax-check
    --flush-cache
    --force-handlers
    --list-hosts
    --list-tags
    --list-tasks
    --start-at-task=`START_AT_TASK`
    --step
    -t `TAGS` --tags=`TAGS`
    --skip-tags=`SKIP_TAGS`

    -k --ask-pass
    --private-key=`PRIVATE_KEY_FILE` --key-file=`PRIVATE_KEY_FILE`
    -u `REMOTE_USER=root` --user=`REMOTE_USER=root`
    -c `CONNECTION=smart` --connection=`CONNECTION=smart`
    -T `TIMEOUT=10s` --timeout=`TIMEOUT=10s`
    --ssh-common-args=`SSH_COMMON_ARGS`
    --sftp-extra-args=`SFTP_EXTRA_ARGS`
    --scp-extra-args=`SCP_EXTRA_ARGS`
    --ssh-extra-args=`SSH_EXTRA_ARGS`

    -b --become
    -K --ask-become-pass
    --become-method=`BECOME_METHOD=sudo`
    --become-user=`BECOME_USER=root`

    playbook.yml [playbook2 ...]
```

## Example

### ansible-vault 

```sh
$ ansible-vault --help
Usage: ansible-vault [create|decrypt|edit|encrypt|encrypt_string|rekey|view] [options] [vaultfile.yml]

encryption/decryption utility for Ansible data files

Options:
  --ask-vault-pass                                      ask for vault password
  --new-vault-id=NEW_VAULT_ID                           the new vault identity to use for rekey
  --new-vault-password-file=NEW_VAULT_PASSWORD_FILES    new vault password file for rekey
  --vault-id=VAULT_IDS                                  the vault identity to use
  --vault-password-file=VAULT_PASSWORD_FILES            vault password file
  -v, --verbose                                         verbose mode (-vvv for more, -vvvv to enable connection debugging)
  --version                                             show program's version number and exit
  -h, --help                                            show this help message and exit

 See 'ansible-vault <command> --help' for more information on a specific command.
```

```sh
ansible-vault create vault.yml
ansible-vault edit vault.yml
ansible-vault view vault.yml
ansible-vault encrypt vault.yml
ansible-vault decrypt vault.yml
ansible-vault rekey vault.yml
```
