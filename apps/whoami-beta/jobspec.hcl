job "beta" {
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

    group "beta" {
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
            name = "beta"
            port = "http"
            tags = [
                "type=service",
                "environment=demo",
                "name=beta",
                "traefik.enable=true",
                "traefik.http.routers.beta.rule=Host(`proxima.ximity.co`) && PathPrefix(`/beta`)",
                "traefik.http.routers.beta.entrypoints=web,websecure",
                "traefik.http.routers.beta.middlewares=strip-beta",
                "traefik.http.middlewares.strip-beta.stripprefix.prefixes=/",
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
        task "beta" {
            driver = "docker"
            config {
                image = "jwilder/whoami"
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
