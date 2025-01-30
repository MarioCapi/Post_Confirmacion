const API_URL_Read = 'http://127.0.0.1:5000/api/client/api/client_read/';
const API_URL_Create = 'http://127.0.0.1:5000/api/client/api/client_create';
const API_URL_Update = 'http://127.0.0.1:5000/api/client/api/client_update';
const API_URL_Delete = 'http://127.0.0.1:5000/api/client/api/client_delete/';

    function showNotification(message) {
        const notification = document.createElement('div');
        notification.className = 'alert alert-success position-fixed top-0 end-0 m-3 animate-fade';
        notification.textContent = message;
        document.body.appendChild(notification);
        setTimeout(() => notification.remove(), 3000);
    }


    async function loadClients(id) {
        try {
            // Hacer la solicitud a la API
            const response = await fetch(API_URL_Read + id);
            if (!response.ok) {
                throw new Error('Error al listar clientes');
            }
    
            // Obtener los datos JSON
            const data = await response.json();
    
            // Obtener el cuerpo de la tabla
            const tableBody = document.getElementById('clientsTableBody');
            tableBody.innerHTML = '';
    
            // Verificar si hay datos
            if (data.message.error) {
                console.error('Error del servidor:', data.message.mensaje);
                return;
            }
    
            // Iterar sobre los datos y agregar filas a la tabla
            data.message.datos.forEach((client) => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${client.nombre_razonsocial}</td>
                    <td>${client.numero_identificacion}</td>
                    <td>${client.correo_electronico}</td>
                    <td>${client.telefono}</td>
                    <td class="actions">
                        <button onclick="editClient(${client.id}, '${client.nombre_razonsocial}', '${client.numero_identificacion}', '${client.correo_electronico}', '${client.telefono}', '${client.direccion_envio}', '${client.direccion_facturacion}')" class="btn btn-primary btn-sm">Editar</button>
                        <button onclick="deleteClient(${client.id})" class="btn btn-danger btn-sm">Eliminar</button>
                    </td>
                `;
                tableBody.appendChild(row);
            });
    
            console.log('Clientes cargados:', data.message.datos);
        } catch (error) {
            console.error('Error al cargar los clientes:', error);
        }
    }


    async function createClient(event) {
        event.preventDefault(); 
        const clientData = {
            nombre_razonsocial: document.getElementById('name').value,
            numero_identificacion: document.getElementById('identification').value,
            correo_electronico: document.getElementById('email').value,
            telefono: document.getElementById('phone').value,
            direccion_envio: document.getElementById('shippingAddress').value,
            direccion_facturacion: document.getElementById('billingAddress').value
        };
    
        try {            
            const response = await fetch(API_URL_Create, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(clientData)
            });
    
            if (!response.ok) {
                throw new Error('Error al crear el cliente');
            }
            const result = await response.json();
            showNotification('Cliente creado exitosamente.');
            console.log(result); 
            document.getElementById('clientForm').reset();
            loadClients('999999999');
        } catch (error) {
            console.error('Error al crear el cliente:', error);
        }
    }



// Rellenar el formulario con los datos del cliente para editar
function editClient(id, nombre, identificacion, email, telefono, direccionEnvio, direccionFacturacion) {    
    document.getElementById('clientId').value = id;
    document.getElementById('name').value = nombre;
    document.getElementById('identification').value = identificacion;
    document.getElementById('email').value = email;
    document.getElementById('phone').value = telefono;
    document.getElementById('shippingAddress').value = direccionEnvio;
    document.getElementById('billingAddress').value = direccionFacturacion;
}


// Función para actualizar el cliente
async function updateClient(event) {
    event.preventDefault(); 
    const clientData = {
        id: document.getElementById('clientId').value,
        nombre_razonsocial: document.getElementById('name').value,
        numero_identificacion: document.getElementById('identification').value,
        correo_electronico: document.getElementById('email').value,
        telefono: document.getElementById('phone').value,
        direccion_envio: document.getElementById('shippingAddress').value,
        direccion_facturacion: document.getElementById('billingAddress').value
    };
    try {
        const response = await fetch(API_URL_Update, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(clientData)
        });

        if (!response.ok) {
            throw new Error('Error al actualizar el cliente');
        }

        const result = await response.json();
        showNotification('Cliente actualizado exitosamente.');
        console.log(result);        
        document.getElementById('clientForm').reset();
        loadClients('999999999');
    } catch (error) {
        console.error('Error al actualizar el cliente:', error);
    }
}


    
    document.addEventListener('DOMContentLoaded', () => {
        loadClients('999999999'); 
    });
    
    /*
    document.getElementById('clientForm').addEventListener('submit', createClient);
*/


// Asignar la función al evento submit del formulario para creación y actualización
document.getElementById('clientForm').addEventListener('submit', function (event) {
    const clientId = document.getElementById('clientId').value;
    if (clientId) {
        updateClient(event); 
    } else {
        createClient(event); 
    }
});


// Función para eliminar un cliente
async function deleteClient(id) {
    if (confirm('¿Está seguro de que desea eliminar este cliente?')) {
        try {
            const response = await fetch(API_URL_Delete + id, {
                method: 'DELETE'
            });

            if (!response.ok) {
                throw new Error('Error al eliminar el cliente');
            }

            showNotification('Cliente eliminado exitosamente.');
            loadClients('999999999');
        } catch (error) {
            console.error('Error al eliminar el cliente:', error);
        }
    }
}