# 清理 configmap
kubectl delete configmaps core -n forethought-core --force --grace-period=0
kubectl delete configmaps kodo kodo-inner kodo-nginx -n forethought-kodo --force --grace-period=0
kubectl delete configmaps front-web-config management-web-config -n forethought-webclient --force --grace-period=0
kubectl delete configmaps message-desk -n middleware --force --grace-period=0
kubectl delete configmaps func-config func-inner-config func-worker-config  -n func --force --grace-period=0
kubectl delete configmaps trigger-conf -n forethought-inner-app --force --grace-period=0
kubectl delete configmaps dataway-config dataway-license -n utils --force --grace-period=0


# 清理 deployment
kubectl delete deployments front-backend inner integration-scanner management-backend websocket -n forethought-core --force --grace-period=0
kubectl delete deployments kodo kodo-inner kodo-nginx -n forethought-kodo --force --grace-period=0
kubectl delete deployments front-webclient management-webclient -n forethought-webclient --force --grace-period=0
kubectl delete deployments message-desk message-desk-worker nsqadmin nsqlookupd nsqd nsqd2 nsqd3 kapacitor kapacitor02 -n middleware --force --grace-period=0
kubectl delete deployments func func-inner func-worker-beat func-worker-debugger func-worker-rpc-crontab func-worker-utils -n func --force --grace-period=0
kubectl delete deployments trigger -n forethought-inner-app --force --grace-period=0
kubectl delete deployments utils-server internal-dataway -n utils --force --grace-period=0

# 清理 service
kubectl delete services front-backend inner integration-scanner management-backend websocket -n forethought-core --force --grace-period=0
kubectl delete services kodo kodo-inner kodo-nginx -n forethought-kodo --force --grace-period=0
kubectl delete services front-webclient management-webclient -n forethought-webclient --force --grace-period=0
kubectl delete services message-desk message-desk-worker nsqadmin nsqlookupd nsqd nsqd2 nsqd3 kapacitor kapacitor02 -n middleware --force --grace-period=0
kubectl delete services func func-inner func-worker-beat func-worker-debugger func-worker-rpc-crontab func-worker-utils -n func --force --grace-period=0
kubectl delete services trigger -n forethought-inner-app --force --grace-period=0
kubectl delete services utils-server internal-dataway -n utils --force --grace-period=0

# 清理 ingress
kubectl delete ingress front-backend management-backend websocket -n forethought-core --force --grace-period=0
kubectl delete ingress front-webclient management-webclient -n forethought-webclient --force --grace-period=0
kubectl delete ingress func -n func --force --grace-period=0

# 清理 PVC
kubectl delete PersistentVolumeClaim ft-sysconfig -n forethought-core --force --grace-period=0
kubectl delete PersistentVolumeClaim kodo-logs kodo-inner-logs -n forethought-kodo --force --grace-period=0
kubectl delete PersistentVolumeClaim  message-desk-logs message-desk-worker-logs nsqd-data-1 nsqd-data-2 nsqd-data-3 kapacitor-data-01 kapacitor-data-02 -n middleware --force --grace-period=0
kubectl delete PersistentVolumeClaim internal-dataway-cache internal-dataway-logs  -n utils --force --grace-period=0


# 清理 secret
kubectl delete secret registry-key -n forethought-core --force --grace-period=0
kubectl delete secret registry-key -n forethought-kodo --force --grace-period=0
kubectl delete secret registry-key -n forethought-inner-app --force --grace-period=0
kubectl delete secret registry-key -n forethought-webclient --force --grace-period=0
kubectl delete secret registry-key -n middleware --force --grace-period=0
kubectl delete secret registry-key -n func --force --grace-period=0
kubectl delete secret registry-key -n utils --force --grace-period=0

# 清理 namespace
# kubectl delete namespaces forethought-core forethought-kodo forethought-inner-app forethought-webclient func --force --grace-period=0
