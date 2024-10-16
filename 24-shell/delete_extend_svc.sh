#!/bin/bash
services=$(kubectl get svc --no-headers | grep extend | cut -d' ' -f1  | tr '\n' ' ')
kubectl delete svc $services
