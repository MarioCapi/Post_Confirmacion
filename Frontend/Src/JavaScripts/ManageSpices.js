const API_URL_Read = 'http://127.0.0.1:5000/api/inventory/api/inventory_read/';
const API_URL_Create = 'http://127.0.0.1:5000/api/inventory/api/inventory_create';
const API_URL_Update = 'http://127.0.0.1:5000/api/inventory/api/inventory_update';
const API_URL_Delete = 'http://127.0.0.1:5000/api/inventory/api/inventory_delete';
let spices = JSON.parse(localStorage.getItem('spices')) || [];
//console.log('Spices cargadas desde localStorage:', spices); 
let editingSpiceId = null; 

async function loadInventory(id) {
    try {
        const response = await fetch(API_URL_Read + id);
        if (!response.ok) {
            throw new Error('Error al cargar el inventario');
        }
        const data = await response.json();

        // Guardar los datos cargados desde el servidor en localStorage
        localStorage.setItem('spices', JSON.stringify(data.message));

        const spiceList = document.getElementById('spiceList');
        spiceList.innerHTML = ''; // Limpiar la lista antes de agregar nuevas filas

        // Iterar sobre los datos y agregar filas a la tabla
        data.message.forEach(spice => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${spice.nombre_especia}</td>
                <td>${spice.cantidad} ${spice.unidad_medida}</td>
                <td>${spice.proveedor}</td>
                <td>$${spice.precio_compra.toFixed(2)}</td>
                <td>
                    <button class="btn btn-sm btn-primary" onclick="editSpice(${spice.id})">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="deleteSpice(${spice.id})">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            `;
            spiceList.appendChild(row);
        });

        console.log('Inventario cargado:', data.message);
    } catch (error) {
        console.error('Error al cargar el inventario:', error);
    }
}

async function createInventory(newSpice) {
    try {        
        const response = await fetch(API_URL_Create, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(newSpice)
        });

        if (!response.ok) {
            throw new Error('Error al crear la especia');
        }

        const data = await response.json();
        console.log('Respuesta de la API:', data);        
        spices.push(newSpice); // Añadimos la especia creada al array
        localStorage.setItem('spices', JSON.stringify(spices));
        showNotification('Especia agregada exitosamente');
        loadInventory('999999999')
    } catch (error) {
        console.error('Error al crear la especia:', error);
        showNotification('Error al agregar la especia');
    }
}


// Función para manejar la actualización de la especia
async function updateInventory(updatedSpice) {
    try {
        const response = await fetch(API_URL_Update, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedSpice),
        });

        const result = await response.json();

        if (response.ok) {
            // Si la actualización es exitosa, actualizamos el inventario
            spices = spices.map(spice => spice.id === updatedSpice.id ? updatedSpice : spice);
            loadInventory('999999999')
            showNotification(result.mensaje || 'Especia actualizada exitosamente');
        } else {
            showNotification('Error al actualizar la especia');
        }
    } catch (error) {
        console.error('Error al actualizar la especia:', error);
        showNotification('Error al actualizar la especia');
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const spiceForm = document.getElementById('spiceForm');
    if (spiceForm) {
        spiceForm.addEventListener('submit', function(e) {
            e.preventDefault(); // Prevenir el comportamiento por defecto del formulario
            const newSpice = {
                id: editingSpiceId, // Usamos el ID de la especia que estamos editando (si existe)
                nombre: document.getElementById('nombre_especia').value,
                cantidad: document.getElementById('cantidad').value,
                unidad_medida: document.getElementById('unidad_medida').value,
                fecha_ingreso: document.getElementById('fecha_ingreso').value,
                proveedor: document.getElementById('proveedor').value,
                precio_compra: document.getElementById('precio_compra').value,
                ubicacion: document.getElementById('ubicacion').value,
                notas: document.getElementById('notas').value
            };

            if (editingSpiceId) {
                // Si estamos editando una especia, actualizamos
                updateInventory(newSpice);
            } else {
                // Si estamos creando una nueva especia
                createInventory(newSpice);
            }

            // Limpiar el ID de la especia editada
            editingSpiceId = null;
            this.reset(); // Restablecer el formulario
        });
    }
});



function editSpice(id) {
    console.log('Editando especia con id:', id); // Verifica el id recibido
    const spices = JSON.parse(localStorage.getItem('spices')) || []; // Asegurarte de cargar los datos desde localStorage
    const spice = spices.find(s => s.id === id);
    console.log('Spice encontrada:', spice); // Verifica la especia encontrada
    
    console.log('Editando especia:', spice); // Verifica que este log se imprime
    if (spice) {
        document.getElementById('nombre_especia').value = spice.nombre_especia;
        document.getElementById('cantidad').value = spice.cantidad;
        document.getElementById('unidad_medida').value = spice.unidad_medida;
        document.getElementById('fecha_ingreso').value = spice.fecha_ingreso ? spice.fecha_ingreso : ''; 
        document.getElementById('proveedor').value = spice.proveedor;
        document.getElementById('precio_compra').value = spice.precio_compra;
        document.getElementById('ubicacion').value = spice.ubicacion;
        document.getElementById('notas').value = spice.notas;
        editingSpiceId = spice.id;
    }
}


// Función para eliminar especia
async function deleteSpice(id) {
    if (confirm('¿Está seguro de eliminar esta especia?')) {
        try {
            const response = await fetch(`${API_URL_Delete}/${id}`, {
                method: 'DELETE',
            });

            if (!response.ok) {
                throw new Error('Error al eliminar la especia');
            }
            const result = await response.json();
            // Actualizar la lista local de especias y el DOM
            spices = spices.filter(spice => spice.id !== id);
            localStorage.setItem('spices', JSON.stringify(spices));
            loadInventory('999999999'); 
            showNotification(result.mensaje || 'Especia eliminada exitosamente');
        } catch (error) {
            console.error('Error al eliminar la especia:', error);
            showNotification('Error al eliminar la especia');
        }
    }
}


        // Función para mostrar notificaciones
        function showNotification(message) {
            const notification = document.createElement('div');
            notification.className = 'alert alert-success position-fixed top-0 end-0 m-3 animate-fade';
            notification.textContent = message;
            document.body.appendChild(notification);
            setTimeout(() => notification.remove(), 3000);
        }

        // Búsqueda en tiempo real
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const filteredSpices = spices.filter(spice => 
                spice.nombre.toLowerCase().includes(searchTerm) ||
                spice.proveedor.toLowerCase().includes(searchTerm)
            );
        });

        document.addEventListener('DOMContentLoaded', () => {
            loadInventory('999999999'); 
        });
