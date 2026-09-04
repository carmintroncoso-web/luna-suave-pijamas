# Luna Suave

Tienda web de pijamas colombianas con catálogo, cuentas, carrito, pedidos, panel administrativo y resumen contable.

## Operación

La versión pública está disponible en https://luna-suave-pijamas.onrender.com/.

El superusuario se crea exclusivamente con las variables privadas `ADMIN_EMAIL` y `ADMIN_PASSWORD` configuradas en Render. No existen credenciales de acceso incluidas en este repositorio.

## Integraciones preparadas

- Wompi para pagos en línea (`WOMPI_PUBLIC_KEY`, `WOMPI_INTEGRITY_SECRET`).
- Resend para correos de confirmación (`RESEND_API_KEY`, `EMAIL_FROM`).
- Coordinadora, Envia, Servientrega e Interrapidísimo mediante las credenciales y contratos de cada empresa.

Mientras falten estas credenciales comerciales, los pagos en línea y las guías reales se mantienen desactivados; el cálculo de entrega opera en modo local identificado como fallback.

## Importante

El plan gratuito de Render usa almacenamiento temporal. Para recibir ventas reales se debe conectar una base de datos persistente antes de operar comercialmente.
