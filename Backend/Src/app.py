from flask import Flask
from flask_cors import CORS
from waitress import serve 


from blueprints.usuarios import usuarios_bp
from blueprints.Products import products_bp
from blueprints.Provider import provider_bp
from blueprints.inventory import invetory_bp
from blueprints.Client import client_bp
from blueprints.ventas import ventas_bp

app = Flask(__name__)
CORS(app)

app.register_blueprint(usuarios_bp, url_prefix='/api/usuarios')
app.register_blueprint(products_bp, url_prefix='/api/products')
app.register_blueprint(provider_bp, url_prefix='/api/providers')
app.register_blueprint(invetory_bp, url_prefix='/api/inventory')
app.register_blueprint(client_bp, url_prefix='/api/client')
app.register_blueprint(ventas_bp, url_prefix='/api/ventas')


#if __name__ == '__main__':
#    app.run(debug=True)

if __name__ == '__main__':
   serve(app, host='0.0.0.0', port=5000)    
