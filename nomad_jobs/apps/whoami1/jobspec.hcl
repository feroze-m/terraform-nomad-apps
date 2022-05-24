job "whoami" {
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

    group "whoami" {
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
            name = "whoami"
            port = "http"
            tags = [
                "type=service",
                "environment=demo",
                "name=whoami",
                "traefik.enable=true",
                "traefik.http.routers.whoami.rule=Host(`whoami.service.consul`) && PathPrefix(`/`)",
                "traefik.http.routers.whoami.entrypoints=web",
                "traefik.http.routers.whoami.middlewares=strip-whoami",
                "traefik.http.middlewares.strip-whoami.stripprefix.prefixes=/",
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
        task "whoami" {
            driver = "docker"
            config {
                image = "jwilder/whoami:latest"
                ports = ["http"]
            }
	    env {
		HOST="0.0.0.0"
		PORT="${NOMAD_PORT_http}"
	    }
            resources {
                cpu     = 100
                memory  = 100
            }
        }
    }
}
