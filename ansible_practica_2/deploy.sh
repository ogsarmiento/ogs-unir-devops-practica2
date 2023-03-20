#!/bin/sh
ansible-playbook playbook-nginx-podman.yml
ansible-playbook playbook-nginx-k8s-pv.yml
