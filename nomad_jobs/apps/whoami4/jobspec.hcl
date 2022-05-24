job "qux" {
    datacenters = "dc1"
    priority = "50"
    type = "service"
    update {
        max_parallel = 1
        health_check = "checks"
        min_healthy_time = "10s"
        healthy_deadline = "3m"
        auto_revert = false
    }
    migrate {
        max_parallel = 1
        health_check = "checks"
        min_healthy_time = "10s"
        healthy_deadline = "5m"
    }

    group "qux" {
        count = 1
        restart {
            interval = "30m"
            attempts = 3
            delay    = "15s"
            mode     = "fail"
        }
        network {
            port "http" {
                to = -1
                host_network = "private"
            }
        }
        service {
            name = "qux"
            port = "http"
            tags = [
                "type=service",
                "environment=demo",
                "name=qux",
                "traefik.enable=true",
                "traefik.http.routers.qux.rule=Host(`qux.service.consul`)",
                "traefik.http.routers.qux.entrypoints=web,websecure",
                "traefik.http.routers.qux.middlewares=strip-qux",
                "traefik.http.middlewares.strip-qux.stripprefix.prefixes=/",
            ]

            check {
                name = "alive"
                type = "tcp"
                port = "http"
                interval = "10s"
                timeout  = "5s"
            }
            check_restart {
                limit = 3
                grace = "90s"
                ignore_warnings = "false"
            }
        }
        task "qux" {
            driver = "docker"
            config {
                image = "jwilder/whoami:latest"
                ports = [ "http" ]
            }
	    env {
		HOST="0.0.0.0"
	    }
            resources {
                cpu     = 100
                memory  = 100
            }
        }
    }
}
