const API_URL_Read = 'http://127.0.0.1:5000/api/providers/api/providers_read';
const API_URL_Create  = 'http://127.0.0.1:5000/api/providers/providers_create';
const API_URL_Delete  = 'http://127.0.0.1:5000/api/providers/api/providers_delete';
const API_URL_Update = 'http://127.0.0.1:5000/api/providers/api/provider_update';



let providers = [];
const itemsPerPage = 20;
let currentPage = 1;

async function fetchProviders() {
    try {
        const response = await fetch(API_URL_Read);
        if (!response.ok) {
            throw new Error(`Error en la solicitud: ${response.status}`);
        }
        const data = await response.json();
        
        // Acceder a los datos de la respuesta correctamente
        if (data.message && data.message.status === 'success') {
            providers = data.message.data || [];  // Los datos están en data.message.data
        } else {
            console.error('Error en la respuesta:', data.message ? data.message.status : 'Respuesta desconocida');
            providers = [];
        }
    } catch (error) {
        console.error('Error al obtener proveedores:', error);
        providers = [];
    }
}
// Llamada a la API para actualizar proveedores
async function updateProvider(provider) {
    try {
        const response = await fetch(API_URL_Update, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(provider),
        });
        if (response.ok) {
            const result = await response.json();
            if (result.error) {
                showError(result.error);
            } else {
                return result;                
            }
        } else {
            showError('Error al actualizar el proveedor');
        }        
    } catch (error) {
        console.error('Error en la solicitud de actualización:', error);
        showError('Error en la solicitud de actualización');
    }
}
// Llamada a la API para crear proveedores
async function createProvider(provider) {
    try {
        // Validar los datos antes de enviarlos
        if (!provider.nit_proveedor || typeof provider.nit_proveedor !== 'number') {
            throw new Error('El campo nit_proveedor es obligatorio y debe ser un número.');
        }
        if (!provider.nombre || typeof provider.nombre !== 'string') {
            throw new Error('El campo nombre es obligatorio y debe ser una cadena de texto.');
        }
        if (!provider.razon || typeof provider.razon !== 'string') {
            throw new Error('El campo razon es obligatorio y debe ser una cadena de texto.');
        }

        // Enviar la solicitud al backend
        const response = await fetch(API_URL_Create, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(provider),
        });

        // Manejar errores de respuesta HTTP
        if (!response.ok) {
            const errorResponse = await response.json();
            throw new Error(errorResponse.error || `Error en la solicitud: ${response.status}`);
        }

        const result = await response.json();

        // Validar respuesta del backend
        if (result.message && result.message.status === 'success') {
            alert(result.message.message);
            return result;
        } else {
            throw new Error(result.error || 'No se pudo crear el proveedor.');
        }
    } catch (error) {
        console.error('Error en la solicitud de creación:', error.message);
        alert(`Error al crear el proveedor: ${error.message}`);
    }
}




async function deleteProvider(nit_proveedor) {
    try {
        if (confirm("¿Está seguro de que desea eliminar este proveedor?")) {
            const response = await fetch(`${API_URL_Delete}/${nit_proveedor}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error(`Error en la solicitud: ${response.statusText}`);
            }

            const data = await response.json();

            if (data.status === 'success') {
                alert('Proveedor eliminado exitosamente');
                // Eliminar el proveedor de la lista local
                providers = providers.filter(provider => provider.nit_proveedor !== nit_proveedor);
                renderProviders(); // Actualizar la tabla
            } else {
                alert(`Error: ${data.message || 'No se pudo eliminar el proveedor'}`);
            }
        }
    } catch (error) {
        console.error('Error al eliminar el proveedor:', error);
        alert('Hubo un error al intentar eliminar el proveedor');
    }
}




async function initializeApp() { 
    await fetchProviders();   
    renderProviders();
    
    
    //renderPagination();
}

 async function renderProviders(filteredProviders = providers) {
    
    const tbody = document.getElementById('productTableBody');
    tbody.innerHTML = '';
    
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const pageProviders = filteredProviders.slice(startIndex, endIndex);

    pageProviders.forEach(provider => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${provider.id_proveedor}</td>
            <td>${provider.nombre_contacto}</td>
            <td>${provider.razon_social}</td>
            <td>${provider.nit_proveedor}</td>
            <td>${provider.telefono_contacto}</td>
            <td>${provider.correo_electronico}</td>
            <td>${provider.direccion}</td>
            <td>
                <button class="btn edit-btn" onclick="editProvider(${provider.id_proveedor})">Editar</button>
                <button class="btn delete-btn" onclick="deleteProvider(${provider.nit_proveedor})">Eliminar</button>
            </td>
        `;
        tbody.appendChild(tr);
    });
    
    addDeleteListeners()
    
}

function renderPagination(filteredProviders = providers) {
    const paginationDiv = document.getElementById('pagination');
    paginationDiv.innerHTML = '';
    
    const pageCount = Math.ceil(filteredProviders.length / itemsPerPage);
    
    for (let i = 1; i <= pageCount; i++) {
        const btn = document.createElement('button');
        btn.innerText = i;
        btn.classList.add('page-btn');
        if (i === currentPage) btn.classList.add('active');
        btn.onclick = () => {
            currentPage = i;
            renderProviders(filteredProviders);
            renderPagination(filteredProviders);
        };
        paginationDiv.appendChild(btn);
    }
}

document.getElementById('form').addEventListener('submit', async function (e) {
    e.preventDefault();

    // Captura los valores del formulario
    const idProveedor = document.getElementById('codeproveedor').value;
    const nombre = document.getElementById('providerName').value.trim();
    const razon = document.getElementById('providerRazon').value.trim();
    const nit = parseInt(document.getElementById('ProviderNit_CC').value, 10); // Convertir a número
    const tel = document.getElementById('ProviderTel').value.trim();
    const email = document.getElementById('providerEmail').value.trim();
    const direccion = document.getElementById('providerAddress').value.trim();

    // Validar los datos antes de enviarlos
    if (isNaN(nit)) {
        alert('El NIT debe ser un número válido.');
        return;
    }
    if (!nombre || !razon || !tel) {
        alert('Por favor completa todos los campos obligatorios.');
        return;
    }
    const provider = {
        nit: nit,
        nombre: nombre,
        razon: razon,
        tel: tel,
        email: email,
        direccion: direccion
    };

    if (idProveedor) {        
        const updatedProvider = await updateProvider(provider);
        if (updatedProvider) {
            const index = providers.findIndex(p => p.id_proveedor == idProveedor);
            if (index !== -1) providers[index] = updatedProvider;
        }
    } else {
        // Crear proveedor
        const newProvider = await createProvider(provider);
        if (newProvider) providers.push(newProvider);
    }
    this.reset();
    document.getElementById('codeproveedor').value = '';
    document.getElementById('submitButton').textContent = 'Crear Proveedor';
    initializeApp();
});




function editProvider(id) {
    const provider = providers.find(p => p.id_proveedor == id);
    document.getElementById('codeproveedor').value = provider.id_proveedor;
    document.getElementById('providerName').value = provider.nombre_contacto;
    document.getElementById('providerRazon').value = provider.razon_social;
    document.getElementById('ProviderNit_CC').value = provider.nit_proveedor;
    document.getElementById('ProviderTel').value = provider.telefono_contacto;
    document.getElementById('providerEmail').value = provider.correo_electronico;
    document.getElementById('providerAddress').value = provider.direccion;

    // Cambiar el texto del botón para indicar que se está actualizando
    document.getElementById('submitButton').textContent = 'Actualizar Proveedor';
}


document.getElementById('searchBar').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const filteredProviders = providers.filter(p => 
        p.razon_social.toLowerCase().includes(searchTerm) ||
        p.nombre_empresa.toLowerCase().includes(searchTerm) ||
        p.nit_proveedor.toString().toLowerCase().includes(searchTerm)
    );
    currentPage = 1;
    renderProviders(filteredProviders);
    //renderPagination(filteredProviders);
});

function addDeleteListeners() {
    const deleteButtons = document.querySelectorAll('.delete-btn');
    deleteButtons.forEach(button => { // Corregido: deleteButtons.forEach
        button.addEventListener('click', (e) => {
            const index = e.target.getAttribute('data-index');
            deleteProvider(index);
        });       
    });
}        

document.addEventListener('DOMContentLoaded', () => {
    initializeApp();
});


