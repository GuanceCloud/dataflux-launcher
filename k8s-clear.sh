# 清理 configmap
kubectl delete configmaps core -n forethought-core
kubectl delete configmaps kodo kodo-inner kodo-nginx -n forethought-kodo
# kubectl delete configmaps message-desk message-desk-worker -n middleware
kubectl delete configmaps front-config management-config -n forethought-webclient


# 清理 deployment
kubectl delete deployment front-backend inner integration-scanner manage-backend websocket -n forethought-core
kubectl delete deployment kodo kodo-inner kodo-nginx -n forethought-kodo
# kubectl delete deployment message-desk message-desk-worker -n middleware
kubectl delete deployment front-webclient manage-webclient -n forethought-webclient

# 清理 service
kubectl delete service front-backend inner integration-scanner manage-backend websocket -n forethought-core
kubectl delete service kodo kodo-inner kodo-nginx -n forethought-kodo
# kubectl delete service message-desk message-desk-worker -n middleware
kubectl delete service front-webclient manage-webclient -n forethought-webclient

# 清理 ingress
kubectl delete ingress front-backend manage-backend websocket -n forethought-core
kubectl delete ingress front-webclient manage-webclient -n forethought-webclient

# 清理 namespace
kubectl delete namespaces forethought-core forethought-kodo forethought-webclient