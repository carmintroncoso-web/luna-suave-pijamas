# Pijamas Colombia API

Backend local, gratuito y sin dependencias externas para un ecommerce de pijamas. Usa Node.js estándar, un archivo JSON persistente y una API HTTP con CORS habilitado. Los precios están expresados como enteros en pesos colombianos (COP).

## Ejecutar

Requiere Node.js 20 o posterior.

```powershell
Copy-Item .env.example .env
node src/server.js
```

La API queda disponible en `http://localhost:3000`. Comprueba con `GET /health` y descarga el contrato OpenAPI en `GET /openapi.yaml` (o `/api/docs`). Al primer arranque se crea `data/store.json` con productos, FAQ y la cuenta administradora. Para volver a los datos de muestra, detén el servidor y borra sólo `data/store.json`.

## Acceso inicial

| Rol | Email | Contraseña |
| --- | --- | --- |
| Administradora | `admin@pijamas.co` | `Admin123!` |

Cambia esta contraseña y `JWT_SECRET` antes de cualquier despliegue. La contraseña se guarda con PBKDF2; el token firmado vence en siete días.

## Flujo principal

1. Crea una cuenta con `POST /api/auth/register`, o inicia sesión en `/api/auth/login`.
2. En los endpoints privados agrega `Authorization: Bearer TU_TOKEN`.
3. Consulta `GET /api/products`, añade variantes con `POST /api/cart/items` y finaliza en `POST /api/checkout`.
4. La administración gestiona catálogo con `POST/PATCH /api/products`, pedidos con `PATCH /api/orders/{id}` y ventas con `GET /api/admin/sales?group=month`.

Ejemplo breve de registro:

```powershell
Invoke-RestMethod -Method Post http://localhost:3000/api/auth/register -ContentType 'application/json' -Body '{"name":"Laura","email":"laura@example.com","password":"ClaveSegura1"}'
```

## Endpoints

| Área | Rutas |
| --- | --- |
| Cuenta | `POST /api/auth/register`, `POST /api/auth/login` |
| Catálogo | `GET/POST /api/products`, `GET/PATCH /api/products/{id-o-slug}` |
| Carrito | `GET /api/cart`, `POST /api/cart/items`, `PATCH/DELETE /api/cart/items/{variantId}` |
| Logística | `POST /api/shipping/quote`, `POST /api/checkout` |
| Pedidos/ventas | `GET /api/orders`, `PATCH /api/orders/{id}`, `GET /api/admin/sales?group=day|week|month|year` |
| Ayuda | `GET /api/faqs`, `POST /api/chat` |

Los errores de validación devuelven HTTP 422 y el cuerpo `{ "error": { "message": "..." } }`.

## Envíos y seguridad

`src/shipping.js` define adaptadores intercambiables para **Coordinadora**, **Envia** y un proveedor **local**. Sin configuración, el fallback local cotiza y genera guías simuladas, por lo que el checkout funciona fuera de línea. Define las variables `COORDINADORA_API_URL`, `COORDINADORA_API_KEY`, `ENVIA_API_URL` y `ENVIA_API_KEY` en `.env`, nunca en código ni en el repositorio. `SHIPPING_PROVIDER=auto` prioriza el primero configurado; se puede solicitar `coordinadora`, `envia` o `local` en las solicitudes de cotización/checkout.

Antes de producción, conecta las llamadas reales siguiendo la documentación contractual vigente de cada transportador, añade una base de datos transaccional y limita CORS a los dominios del frontend.

## Publicar gratis en Render

El archivo `render.yaml` prepara una instancia web gratuita. Después de subir este proyecto a GitHub, entra a [Render](https://render.com/), conecta tu cuenta de GitHub y crea un **Blueprint** desde el repositorio. Render leerá el archivo, generará un secreto seguro para los tokens y publicará una dirección `https://…onrender.com` con HTTPS.

El plan gratuito se suspende tras 15 minutos sin tráfico y tarda aproximadamente un minuto en despertar. Su disco es temporal: usuarios, carritos y pedidos creados en la tienda se reinician al redesplegar o reiniciar el servicio. Es adecuado como demostración pública. Para una operación comercial persistente, conecta una base de datos gestionada antes de recibir pedidos reales.
