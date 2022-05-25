job "traefik" {
    datacenters = "dc1"
    priority = "100"
    type = "system"
    update {
        max_parallel = 1
        health_check = "checks"
        min_healthy_time = "10s"
        healthy_deadline = "3m"
        auto_revert = false
    }

    group "traefik" {
        restart {
            interval = "30m"
            attempts = 3
            delay    = "15s"
            mode     = "fail"
        }
        network {
            port "web" {
                static = 28080
                to = 28080
                host_network = "private"
            }
            port "websecure" {
                static = 28443
                to = 28443
                host_network = "private"
            }
            port "api" {
                static = 28081
                to = 28081
                host_network = "private"
            }
        }
        service {
            name = "traefik"
	    port = "web"
            tags = [
                "type=system",
                "environment=demo",
                "name=traefik",
		"traefik.enable=true",
		"traefik.http.routers.dashboard.rule=(PathPrefix(`/api`) || PathPrefix(`/dashboard`))",
		"traefik.http.routers.dashboard.service=api@internal",
		"traefik.http.routers.dashboard.entrypoints=traefik",
		"traefik.http.routers.dashboard.middlewares=dashboard-auth",
		"traefik.http.middlewares.dashboard-auth.basicauth.users=admin:$2a$04$KAcClbyEYxtF6s1UeEG1HOLLZTUVTfu4W0PPQ1rftX3CG.Oh0.pf2",
		"traefik.http.middlewares.dashboard-auth.basicauth.removeHeader=true",

#                "traefik.http.routers.https.rule=Host(`traefik.proxima-myapp.com)",
#                "traefik.http.routers.https.entrypoints=websecure",
#                "traefik.http.routers.https.tls=true",
#                "traefik.http.routers.https.service=api@internal",

#                "traefik.http.middleware.redirect.redirectscheme.scheme=https",
#                "traefik.http.middleware.redirect.redirectscheme.permanent=true"
            ]

            check {
                name = "alive"
                type = "tcp"
                port = "api"
                interval = "10s"
                timeout  = "5s"
            }
            check_restart {
                limit = 3
                grace = "90s"
                ignore_warnings = "false"
            }
        }
        task "traefik" {
            driver = "docker"
            config {
                image = "traefik:v2.6"
                network_mode = "host"
                volumes = [
                  "local/traefik.toml:/etc/traefik/traefik.toml",
                  "local/nomad-ui.toml:/etc/traefik/nomad-ui.toml"
                ]
            }

            template {
                change_mode = "restart"
                data = <<EOF
                [entryPoints]
                    [entryPoints.web]
                        address = ":28080"
                    [entryPoints.websecure]
                        address = ":28443"
                    [entryPoints.traefik]
                        address = ":28081"

                [web]
                    insecure = true

                [api]
                    dashboard = true

                [providers]
                    [providers.file]
                        directory = "/etc/traefik"
                        watch = true

                    [providers.consulCatalog]
                        prefix = "traefik"
                        exposedByDefault = false
                        [providers.consulCatalog.endpoint]
                        address = "127.0.0.1:8500"
                        scheme  = "http"

		    [providers.consul]
			rootKey = "traefik"
			endpoints = ["127.0.0.1:8500"]
                
                [log]
                    level = "INFO"
                [accessLog]
                    [accessLog.fields.headers]
                        defaultMode = "keep"
                
                EOF
                    destination = "local/traefik.toml"
            }
            
            template {
                data = <<EOF
                [http]
                    [http.routers]
                        [http.routers.nomad-ui]
                            rule = "Host(`10.0.1.31`) && PathPrefix(`/nomad`)"
                            service = "nomad-ui"
			    entrypoints = ["web"]
			    middlewares = ["dashboard-auth@consulcatalog"]
                    [http.services]
                        [http.services.nomad-ui.loadBalancer]
                            [[http.services.nomad-ui.loadBalancer.servers]]
                                url = "http://nomadserver01.node.consul:4646/"
                            [[http.services.nomad-ui.loadBalancer.servers]]
                                url = "http://nomadserver02.node.consul:4646/"
                            [[http.services.nomad-ui.loadBalancer.servers]]
                                url = "http://10.0.1.23:4646/"
                EOF
                    destination = "local/nomad-ui.toml"
            }

            resources {
                cpu     = 300
                memory  = 128
            }
        }
    }
}
