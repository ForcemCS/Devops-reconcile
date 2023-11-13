#!/bin/bash
kubeadm init  --kubernetes-version=v1.27.1  --apiserver-advertise-address=12.0.0.20  --pod-network-cidr="192.168.0.0/16" --node-name master01
