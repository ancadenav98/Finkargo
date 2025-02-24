# Arquitectura de Red VPC con NAT en AWS usando Terraform

Este proyecto Terraform implementa una arquitectura de red básica en AWS que incluye una VPC, subredes públicas y privadas, una instancia NAT y un Internet Gateway.  El diseño permite que las instancias en las subredes privadas accedan a Internet a través de la instancia NAT, mientras que las instancias en las subredes públicas tienen acceso directo.

## Arquitectura

La arquitectura incluye los siguientes componentes:

* **VPC:** Un espacio de red aislado en AWS.
* **Subredes públicas (2):**  Alojan recursos que requieren acceso directo a Internet, como la instancia NAT.
* **Subredes privadas (2):** Alojan recursos que no necesitan acceso directo a Internet.
* **Instancia NAT:** Actúa como gateway para las subredes privadas, permitiéndoles acceder a Internet.
* **Internet Gateway:** Proporciona conectividad entre la VPC e Internet.
* **Tablas de rutas:** Definen cómo se enruta el tráfico desde las subredes.
* **Asociaciones de tablas de rutas:** Conectan las subredes a sus respectivas tablas de rutas.

## Flujo del tráfico

* **Subredes privadas -> Internet:** El tráfico se enruta a la instancia NAT, que realiza la traducción de direcciones de red (NAT) y envía el tráfico a Internet a través del Internet Gateway.
* **Subredes públicas -> Internet:** El tráfico se envía directamente al Internet Gateway.


## Modularización

El proyecto utiliza módulos Terraform para una mejor organización y reutilización del código. Los módulos incluidos son:

* `vpc`: Crea la VPC, las subredes, el Internet Gateway, las tablas de rutas y las asociaciones.
* `nat_instance`: Crea y configura la instancia NAT, incluyendo su security group.
* `internet_gateway`: Crea el Internet Gateway.
* `route_table`: Crea una tabla de rutas.

## Variables

Las variables de entrada se definen en el archivo `variables.tf` y se les asignan valores en `terraform.auto.tfvars`.  Esto permite una fácil gestión de la configuración y la posibilidad de usar diferentes valores para distintos entornos.

## Requisitos previos

* Terraform instalado.
* Credenciales de AWS configuradas.

## Despliegue

1. Clona este repositorio.
2. Navega al directorio del proyecto.
3. Inicializa Terraform: `terraform init`
4. Revisa el plan de ejecución: `terraform plan -var-file=terraform.tfvars`
5. Aplica la configuración: `terraform apply -var-file=terraform.tfvars`

## Destrucción

Para destruir la infraestructura creada, ejecuta:

```bash
terraform destroy -var-file=terraform.tfvars
