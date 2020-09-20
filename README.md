Arch Linux Dockerfile for my testing / packaging environment

- base-devel
- multilib
- sudo (user: `pwner`)
- yay


```
kubectl run archlinux --image=ac1965/archlinux
kubectl get pod -o wide
kubectl delete pod archlinux
```
