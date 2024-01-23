CASSANDRA_CLUSTER_NAME := my-cassandra
CASSANDRA_REPLICAS := 1
CASSANDRA_IMAGE := cassandra:latest
CASSANDRA_MEMORY_LIMIT := 12Gi
CASSANDRA_CPU_LIMIT := 2
CASSANDRA_CLUSTER_SEEDS := $(shell \
	for i in $$(seq 0 $$(expr $(CASSANDRA_REPLICAS) - 1)); do \
		echo -n "$$i-cassandra.cassandra.default.svc.cluster.local,"; \
	done | sed 's/,$$//')

deploy-cassandra:
	helm upgrade --install $(CASSANDRA_CLUSTER_NAME) ./cassandra-chart \
		--set cassandra.replicas=$(CASSANDRA_REPLICAS) \
		--set cassandra.image=$(CASSANDRA_IMAGE) \
		--set cassandra.clusterName=$(CASSANDRA_CLUSTER_NAME) \
		--set cassandra.memoryLimit=$(CASSANDRA_MEMORY_LIMIT) \
		--set cassandra.cpuLimit=$(CASSANDRA_CPU_LIMIT) \
		--set cassandra.clusterSeeds=$(CASSANDRA_CLUSTER_SEEDS)

client-app: deploy-cassandra
	kubectl wait --for=condition=available deployment/$(CASSANDRA_CLUSTER_NAME) --timeout=300s
	kubectl exec -it $$(kubectl get pods -l app=cassandra -o jsonpath='{.items[0].metadata.name}') -- bash -il
