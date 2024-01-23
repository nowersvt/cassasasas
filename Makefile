CASSANDRA_CLUSTER_NAME := my-cassandra
CASSANDRA_REPLICAS := 1
CASSANDRA_IMAGE := cassandra:latest
CASSANDRA_MEMORY_LIMIT := 12Gi
CASSANDRA_CPU_LIMIT := 2


CASSANDRA_SEEDS_HOST_NAME := \
    "cassandra-0.cassandra.default.svc.cluster.local" \
    "cassandra-1.cassandra.default.svc.cluster.local" \
    "cassandra-2.cassandra.default.svc.cluster.local" \
	"cassandra-3.cassandra.default.svc.cluster.local"


deploy-cassandra:
	helm upgrade --install $(CASSANDRA_CLUSTER_NAME) ./cassandra-chart \
		--set cassandra.replicas=$(CASSANDRA_REPLICAS) \
		--set cassandra.image=$(CASSANDRA_IMAGE) \
		--set cassandra.clusterName=$(CASSANDRA_CLUSTER_NAME) \
		--set cassandra.memoryLimit=$(CASSANDRA_MEMORY_LIMIT) \
		--set cassandra.cpuLimit=$(CASSANDRA_CPU_LIMIT) \
		--set cassandra.seedHostnames=$(CASSANDRA_SEEDS_HOST_NAME)


connect-cassandra-pod: 
	kubectl exec -it $$(kubectl get pods -l app=cassandra -o jsonpath='{.items[0].metadata.name}') -- bash -il

connect-cassandra-db: 
	kubectl exec -it $$(kubectl get pods -l app=cassandra -o jsonpath='{.items[0].metadata.name}') -- cqlsh