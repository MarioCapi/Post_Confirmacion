import requests


#create ventas
url = "http://127.0.0.1:5000/api/ventas/api/ventas_create"
data = {
    "consecutivo_factura": 12345,
    "numero_identi_cliente": "123456789",
    "estado": "Pendiente",
    "formapago": "DEBE",
    "productos_json": [
        {"producto_id": 1, "cantidad": 91 },
        {"producto_id": 2, "cantidad": 7}
    ]
}

response = requests.post(url, json=data)
print("Status Code:", response.status_code)
print("Response JSON:", response.json())





#  read ventas
#  http://127.0.0.1:5000/api/ventas/api/ventas_read
{
    "fecha_inicio": "2024-11-01",
    "fecha_final": "2024-11-27",
    "numero_identificacion": "9988",
    "codeproducto": 10,
    "consecutivo_factura": 1001
}#respuesta:
{
    "cantidad": 7,
    "codeproducto": 10,
    "consecutivo_factura": 1007,
    "estado": "CREADA",
    "estado_formapago": "PAGADA",
    "fecha_venta": "2024-11-25T19:04:32.407603",
    "id_venta": 6,
    "nombre_producto": "albahaca",
    "nombre_razonsocial": "empresa front",
    "numero_identificacion": "9988",
    "precio_unitario": 525.0,
    "total": 3675.0
}
