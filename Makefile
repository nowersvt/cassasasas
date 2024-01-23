CASSANDRA_CLUSTER_NAME := my-cassandra
CASSANDRA_IMAGE := cassandra:latest

CASSANDRA_REPLICAS := 1
CASSANDRA_MEMORY_LIMIT := 12Gi
CASSANDRA_CPU_LIMIT := 2
CASSANDRA_STORAGE_CAPACITY := 10Gi
deploy-cassandra:
	helm upgrade --install $(CASSANDRA_CLUSTER_NAME) ./cassandra-chart \
		--set cassandra.replicas=$(CASSANDRA_REPLICAS) \
		--set cassandra.image=$(CASSANDRA_IMAGE) \
		--set cassandra.clusterName=$(CASSANDRA_CLUSTER_NAME) \
		--set cassandra.memoryLimit=$(CASSANDRA_MEMORY_LIMIT) \
		--set cassandra.cpuLimit=$(CASSANDRA_CPU_LIMIT) \
		--set cassandra.storageCapacity=$(CASSANDRA_STORAGE_CAPACITY)


testConnect-to-db: 
	kubectl exec -it cassandra-0 -- sh -c "cqlsh -e 'SHOW HOST'"

connect-cassandra-db: 
	kubectl exec -it cassandra-0 -- cqlsh	
connect-app-client:
	kubectl exec -it cassandra-0 -- /bin/sh
