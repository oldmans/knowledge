# etcd

## CLI

* etcd

```sh
$ etcd -h
usage: etcd [flags]
       start an etcd server

       etcd --version
       show the version of etcd

       etcd -h | --help
       show the help information about etcd

       etcd --config-file
       path to the server configuration file


member flags:

	--name 'default'
		human-readable name for this member.
	--data-dir '${name}.etcd'
		path to the data directory.
	--wal-dir ''
		path to the dedicated wal directory.
	--snapshot-count '10000'
		number of committed transactions to trigger a snapshot to disk.
	--heartbeat-interval '100'
		time (in milliseconds) of a heartbeat interval.
	--election-timeout '1000'
		time (in milliseconds) for an election to timeout. See tuning documentation for details.
	--listen-peer-urls 'http://localhost:2380'
		list of URLs to listen on for peer traffic.
	--listen-client-urls 'http://localhost:2379'
		list of URLs to listen on for client traffic.
	--max-snapshots '5'
		maximum number of snapshot files to retain (0 is unlimited).
	--max-wals '5'
		maximum number of wal files to retain (0 is unlimited).
	--cors ''
		comma-separated whitelist of origins for CORS (cross-origin resource sharing).
	--quota-backend-bytes '0'
		raise alarms when backend size exceeds the given quota (0 defaults to low space quota).

clustering flags:

	--initial-advertise-peer-urls 'http://localhost:2380'
		list of this member's peer URLs to advertise to the rest of the cluster.
	--initial-cluster 'default=http://localhost:2380'
		initial cluster configuration for bootstrapping.
	--initial-cluster-state 'new'
		initial cluster state ('new' or 'existing').
	--initial-cluster-token 'etcd-cluster'
		initial cluster token for the etcd cluster during bootstrap.
		Specifying this can protect you from unintended cross-cluster interaction when running multiple clusters.
	--advertise-client-urls 'http://localhost:2379'
		list of this member's client URLs to advertise to the public.
		The client URLs advertised should be accessible to machines that talk to etcd cluster. etcd client libraries parse these URLs to connect to the cluster.
	--discovery ''
		discovery URL used to bootstrap the cluster.
	--discovery-fallback 'proxy'
		expected behavior ('exit' or 'proxy') when discovery services fails.
		"proxy" supports v2 API only.
	--discovery-proxy ''
		HTTP proxy to use for traffic to discovery service.
	--discovery-srv ''
		dns srv domain used to bootstrap the cluster.
	--strict-reconfig-check
		reject reconfiguration requests that would cause quorum loss.
	--auto-compaction-retention '0'
		auto compaction retention in hour. 0 means disable auto compaction.

proxy flags:
	"proxy" supports v2 API only.

	--proxy 'off'
		proxy mode setting ('off', 'readonly' or 'on').
	--proxy-failure-wait 5000
		time (in milliseconds) an endpoint will be held in a failed state.
	--proxy-refresh-interval 30000
		time (in milliseconds) of the endpoints refresh interval.
	--proxy-dial-timeout 1000
		time (in milliseconds) for a dial to timeout.
	--proxy-write-timeout 5000
		time (in milliseconds) for a write to timeout.
	--proxy-read-timeout 0
		time (in milliseconds) for a read to timeout.


security flags:

	--ca-file '' [DEPRECATED]
		path to the client server TLS CA file. '-ca-file ca.crt' could be replaced by '-trusted-ca-file ca.crt -client-cert-auth' and etcd will perform the same.
	--cert-file ''
		path to the client server TLS cert file.
	--key-file ''
		path to the client server TLS key file.
	--client-cert-auth 'false'
		enable client cert authentication.
	--trusted-ca-file ''
		path to the client server TLS trusted CA key file.
	--auto-tls 'false'
		client TLS using generated certificates.
	--peer-ca-file '' [DEPRECATED]
		path to the peer server TLS CA file. '-peer-ca-file ca.crt' could be replaced by '-peer-trusted-ca-file ca.crt -peer-client-cert-auth' and etcd will perform the same.
	--peer-cert-file ''
		path to the peer server TLS cert file.
	--peer-key-file ''
		path to the peer server TLS key file.
	--peer-client-cert-auth 'false'
		enable peer client cert authentication.
	--peer-trusted-ca-file ''
		path to the peer server TLS trusted CA file.
	--peer-auto-tls 'false'
		peer TLS using self-generated certificates if --peer-key-file and --peer-cert-file are not provided.

logging flags

	--debug 'false'
		enable debug-level logging for etcd.
	--log-package-levels ''
		specify a particular log level for each etcd package (eg: 'etcdmain=CRITICAL,etcdserver=DEBUG').
	--log-output 'default'
		specify 'stdout' or 'stderr' to skip journald logging even when running under systemd.

unsafe flags:

Please be CAUTIOUS when using unsafe flags because it will break the guarantees
given by the consensus protocol.

	--force-new-cluster 'false'
		force to create a new one-member cluster.

profiling flags:
	--enable-pprof 'false'
		Enable runtime profiling data via HTTP server. Address is at client URL + "/debug/pprof/"
	--metrics 'basic'
	  Set level of detail for exported metrics, specify 'extensive' to include histogram metrics.


```

* etcdctl

```sh
$ etcdctl
NAME:
   etcdctl - A simple command line client for etcd.

USAGE:
   etcdctl [global options] command [command options] [arguments...]

VERSION:
   3.1.0

COMMANDS:
     mk              make a new key with a given value
     mkdir           make a new directory
     update          update an existing key with a given value
     updatedir       update an existing directory
     set             set the value of a key
     setdir          create a new directory or update an existing directory TTL
     rm              remove a key or a directory
     rmdir           removes the key if it is an empty directory or a key-value pair
     get             retrieve the value of a key
     ls              retrieve a directory

     watch           watch a key for changes
     exec-watch      watch a key for changes and exec an executable

     member          member add, remove and list subcommands
     cluster-health  check the health of the etcd cluster

     user            user add, grant and revoke subcommands
     role            role add, grant and revoke subcommands
     auth            overall auth controls

     backup          backup an etcd directory
     help, h         Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --debug                          output cURL commands which can be used to reproduce the request
   --no-sync                        don't synchronize cluster information before sending request
   --output simple, -o simple       output response in the given format (simple, `extended` or `json`) (default: "simple")
   --discovery-srv value, -D value  domain name to query for SRV records describing cluster endpoints
   --insecure-discovery             accept insecure SRV records describing cluster endpoints
   --peers value, -C value          DEPRECATED - "--endpoints" should be used instead
   --endpoint value                 DEPRECATED - "--endpoints" should be used instead
   --endpoints value                a comma-delimited list of machine addresses in the cluster (default: "http://127.0.0.1:2379,http://127.0.0.1:4001")
   --cert-file value                identify HTTPS client using this SSL certificate file
   --key-file value                 identify HTTPS client using this SSL key file
   --ca-file value                  verify certificates of HTTPS-enabled servers using this CA bundle
   --username value, -u value       provide username[:password] and prompt if password is not supplied.
   --timeout value                  connection timeout per request (default: 2s)
   --total-timeout value            timeout for the command execution (except watch) (default: 5s)
   --help, -h                       show help
   --version, -v                    print the version
```

```sh
$ etcdctl member
NAME:
   etcdctl member - member add, remove and list subcommands

USAGE:
   etcdctl member command [command options] [arguments...]

COMMANDS:
     list    enumerate existing cluster members
     add     add a new member to the etcd cluster
     remove  remove an existing member from the etcd cluster
     update  update an existing member in the etcd cluster

OPTIONS:
   --help, -h  show help

```

```sh
$ etcdctl user
NAME:
   etcdctl user - user add, grant and revoke subcommands

USAGE:
   etcdctl user command [command options] [arguments...]

COMMANDS:
     add     add a new user for the etcd cluster
     get     get details for a user
     list    list all current users
     remove  remove a user for the etcd cluster
     grant   grant roles to an etcd user
     revoke  revoke roles for an etcd user
     passwd  change password for a user

OPTIONS:
   --help, -h  show help

```

```sh
$ etcdctl role
NAME:
   etcdctl role - role add, grant and revoke subcommands

USAGE:
   etcdctl role command [command options] [arguments...]

COMMANDS:
     add     add a new role for the etcd cluster
     get     get details for a role
     list    list all roles
     remove  remove a role from the etcd cluster
     grant   grant path matches to an etcd role
     revoke  revoke path matches for an etcd role

OPTIONS:
   --help, -h  show help

```
