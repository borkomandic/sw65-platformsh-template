# Boilerplate for Webstore

This is a boilerplate template designed for setting up a Shopware 6.6 store. It includes integration with Platform.sh PAAS, ensuring a robust and scalable e-commerce environment.

## Template Overview

This template features a decoupled `.src/` directory containing all Shopware 6 (SW6) related components. Project configuration, DevOps practices, git repository management, and all other operational aspects are managed in the root directory (`./`).

## Tech Overview

The technology stack for this boilerplate includes:

- **Shopware**: Version 6.6.1.2, core platform providing the e-commerce framework.
- **Symfony Flex**: Used for managing Symfony configurations and recipes, enhancing the project's modularity and flexibility.
- **PHP**: Version 8.3
- **MariaDB**: Version 10.11
- **Adminer**: Database management tool
- **Redis**: Version 7.0, used for caching and session storage
- **OpenSearch**: Version 2.0, for powerful search capabilities
- **Composer**: Version 2.7, for dependency management
- **Docker & Docker Compose**: For container management and orchestration
- **Dockware**: Custom Docker image for Shopware, modified to use a custom Apache user (instead of the default `www-data`)

This setup provides a comprehensive environment tailored for developing and deploying high-performance Shopware stores.
