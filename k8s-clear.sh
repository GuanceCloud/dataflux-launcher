# 清理 configmap
kubectl delete configmaps core -n forethought-core
kubectl delete configmaps kodo kodo-inner kodo-nginx -n forethought-kodo
kubectl delete configmaps front-web-config management-web-config -n forethought-webclient
kubectl delete configmaps message-desk -n middleware


# 清理 deployment
kubectl delete deployments front-backend inner integration-scanner management-backend websocket -n forethought-core
kubectl delete deployments kodo kodo-inner kodo-nginx -n forethought-kodo
kubectl delete deployments front-webclient management-webclient -n forethought-webclient
kubectl delete deployments message-desk message-desk-worker -n middleware

# 清理 service
kubectl delete services front-backend inner integration-scanner management-backend websocket -n forethought-core
kubectl delete services kodo kodo-inner kodo-nginx -n forethought-kodo
kubectl delete services front-webclient management-webclient -n forethought-webclient
kubectl delete services message-desk message-desk-worker -n middleware

# 清理 ingress
kubectl delete ingress front-backend management-backend websocket -n forethought-core
kubectl delete ingress front-webclient management-webclient -n forethought-webclient

# 清理 namespace
kubectl delete namespaces forethought-core forethought-kodo forethought-webclient func
