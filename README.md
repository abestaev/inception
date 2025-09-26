# Inception

This project aims to broaden your knowledge of system administration through the use of Docker technology. You will virtualize several Docker images by creating them in your new personal virtual machine.

## 🚀 Project Overview

Inception is a multi-container Docker application that sets up a complete WordPress website with a reverse proxy, database, and bonus services for enhanced functionality.

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Nginx       │    │   WordPress     │    │    MariaDB      │
│   (Port 443)    │◄──►│   (Port 9000)   │◄──►│   (Port 3306)   │
│   SSL/TLS       │    │   PHP-FPM       │    │   Database      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │     Redis       │
                       │   (Port 6379)   │
                       │     Cache       │
                       └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │   FTP Server    │
                       │   (Port 21)     │
                       │  File Access    │
                       └─────────────────┘
```

## 📦 Services

### Core Services
- **WordPress** - Content Management System
- **MariaDB** - Database server
- **Nginx** - Reverse proxy with SSL/TLS

### Bonus Services
- **Redis** - Object cache for WordPress performance
- **FTP Server** - File access to WordPress volume

## 🛠️ Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/abestaev/inception.git
   cd inception
   ```

2. **Create environment file**
   ```bash
   cp srcs/.env.example srcs/.env
   # Edit srcs/.env with your configuration
   ```

3. **Create secrets directory**
   ```bash
   mkdir -p srcs/secrets
   # Add your password files:
   # - mysql_password
   # - mysql_root_password
   # - wordpress_admin_password
   # - redis_password
   # - ftp_password
   ```

4. **Start the services**
   ```bash
   cd srcs
   docker compose up --build -d
   ```

5. **Access the website**
   - Website: https://localhost or https://albestae.42.fr
   - Admin: https://albestae.42.fr/wp-admin
   - FTP: localhost:21 (user: ftpuser)

## 🔧 Configuration

### Environment Variables
Edit `srcs/.env` to customize:
- Domain names
- Database credentials
- Admin credentials
- Ports

### Secrets
Place password files in `srcs/secrets/`:
- `mysql_password` - MariaDB user password
- `mysql_root_password` - MariaDB root password
- `wordpress_admin_password` - WordPress admin password
- `redis_password` - Redis password
- `ftp_password` - FTP user password

## 📁 Project Structure

```
inception/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   ├── secrets/
│   └── requirements/
│       ├── mariadb/          # Database service
│       ├── nginx/            # Reverse proxy
│       ├── wordpress/        # CMS
│       └── bonus/            # Bonus services
│           ├── redis/        # Cache service
│           ├── ftp/          # FTP server
│           └── README.md     # Bonus services documentation
└── README.md
```

## 🔐 Security

- SSL/TLS encryption with self-signed certificates
- Secrets management through Docker secrets
- Isolated containers with custom networks
- No sensitive data in version control (.gitignore configured)

## 🚀 Features

- **WordPress** with PHP 8.2 and FPM
- **MariaDB** database with custom configuration
- **Nginx** reverse proxy with SSL termination
- **Redis** object cache for performance
- **FTP** server for file management
- **Docker Compose** orchestration
- **Persistent volumes** for data storage

## 📝 Usage

### WordPress Admin
- URL: https://albestae.42.fr/wp-admin
- Username: manager
- Password: (from secrets/wordpress_admin_password)

### FTP Access
- Host: localhost
- Port: 21
- Username: ftpuser
- Password: (from secrets/ftp_password)

### Redis Cache
- Host: localhost
- Port: 6379
- Password: (from secrets/redis_password)

## 🛠️ Development

### Rebuilding Services
```bash
docker compose up --build -d [service_name]
```

### Viewing Logs
```bash
docker compose logs [service_name]
```

### Stopping Services
```bash
docker compose down
```

## 📚 Documentation

- [Bonus Services Documentation](srcs/requirements/bonus/README.md)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [WordPress Documentation](https://wordpress.org/support/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is part of the 42 School curriculum.
