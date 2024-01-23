CASSANDRA_CLUSTER_NAME := my-cassandra
CASSANDRA_REPLICAS := 1
CASSANDRA_IMAGE := cassandra:latest
CASSANDRA_MEMORY_LIMIT := 12Gi
CASSANDRA_CPU_LIMIT := 2

deploy-cassandra:
	helm upgrade --install $(CASSANDRA_CLUSTER_NAME) ./cassandra-chart \
		--set cassandra.replicas=$(CASSANDRA_REPLICAS) \
		--set cassandra.image=$(CASSANDRA_IMAGE) \
		--set cassandra.clusterName=$(CASSANDRA_CLUSTER_NAME) \
		--set cassandra.memoryLimit=$(CASSANDRA_MEMORY_LIMIT) \
		--set cassandra.cpuLimit=$(CASSANDRA_CPU_LIMIT)


testConnect-to-db: 
	kubectl exec -it cassandra-0 -- sh -c "cqlsh -e 'SHOW HOST'"

connect-cassandra-db: 
	kubectl exec -it cassandra-0 -- cqlsh
connect-app-client:
	kubectl exec -it cassandra-0 -- /bin/sh
