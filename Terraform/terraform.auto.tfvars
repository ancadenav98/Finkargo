#Almaceno los inputs para las variables necesarias en el archivo tfvars, permitiendo flexiblidad en la configuración del despliegue sin modificar el código.
vpc_cidr = "10.0.0.0/16"
public_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr = ["10.0.101.0/24", "10.0.102.0/24"]
