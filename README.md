# Modelo Anidados


Lo primero que hay que tener en cuenta es que un modelo anidado que contiene una relación `has_many` con otro modelo.

En ocasiones, tenemos modelos asociados que necesitamos manipular en un único formulario en lugar de tener un formulario por cada uno de ellos.

Un formulario anidado nos permite generar una mejor experiencia de usuario al trabajar con modelos relacionados. De esta manera no se tendrá que estar cambiando a las vistas de cada modelo para hacer cambios.

En este tutorial crearemos formularios anidados **(nested forms)** ⛓ para listar **Bancos y sus sucursales**. Al finalizar, podremos editar un banco y sus sucursales es un único formulario 📝.

### Tabla de contenidos
1. [Crear el proyecto](#paso1)
2. [Crear scaffolds](#paso2)
3. [Asociando los modelos y creando las validaciones](#paso3)
4. [Mostrando las sucursales en el detalle del banco](#paso4)
2. [Modificando el formulario del modelo bank](#paso5)
2. [Editando una sucursal](#paso6)
2. [Agregar una nueva sucursal](#paso7)
2. [Borrar una sucursal](#paso8)
2. [Más información](#more-info)
2. [Siguientes pasos](#next-steps)


## Crear el proyecto <a name="paso1"></a>

```ruby
rails new Bancos
cd Bancos
```


## Crear scaffolds <a name="paso2"></a>

> *Scaffold* se refiere a la generación automática de un conjunto simple de modelo, vista y controlador. Es una forma rápida de generar la mayor parte de piezas de una aplicación.

Vamos a necesitar los siguientes dos **scaffolds** para nuestro ejemplo:


```ruby
rails g scaffold Bank name:string
rails g scaffold BankSubsidiary address:string bank:references
```

La opción `:references` crea un campo que hace referencia al modelo, en este caso `bank`.

```ruby
rake db:migrate
```
Tenemos que ejecutar la migración puesto que hemos creado un nuevo modelo.

> Las migraciones son clases de Ruby que están diseñadas para simplificar la creación y modificación de tablas en la base de datos. Rails usa el comando rake para ejecutar las migraciones.

 Revisemos el schema.

 ```ruby
 ActiveRecord::Schema.define(version: 20150507004618) do

  create_table "bank_subsidiaries", force: :cascade do |t|
    t.string   "address"
    t.integer  "bank_id" # campo creado con la opción :references  
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bank_subsidiaries", ["bank_id"], name: "index_bank_subsidiaries_on_bank_id"

  create_table "banks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
 ```


## Asociando los modelos y creando las validaciones <a name="paso3"></a>

Ahora vamos a crear la asociación entre los modelos, que en este caso es una relación de `uno a muchos`. Es decir, **un banco puede tener muchas sucursales pero una sucursal solo puede pertenecer a un banco**. También validaremos los campos que son obligatorios para nuestros modelos.

> 💡**Tip:** se puede añadir un método llamado `to_s` y pedirle que imprima la columna que queremos cuando llamamos al objeto y así no tener que especificarlo cada vez que lo usamos. Ej: `instancia` v/s `instancia.columna`


```ruby
class Bank < ActiveRecord::Base
  has_many :bank_subsidiaries, dependent: :destroy
  validates :name, presence: true

  def to_s
    name
  end
end
```

```ruby
class BankSubsidiary < ActiveRecord::Base
  belongs_to :bank
  validates :address, presence: true

  def to_s
    address
  end
end
```

Usaremos el archivo `db/seeds.rb` para crear datos para probar la aplicación.

```ruby
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

scotiabank = Bank.create(name: 'Banco Scotiabank')
interbank = Bank.create(name: 'Banco Interbank')
['Av. La Molina 562, Lima', 'Av. Risso 5561 Of. 202 P.2 - Lince', 'Agustinas N° 1070 P. 6 Of. 52, Centro Cívico'].each do |bs|
  scotiabank.bank_subsidiaries.create(address: bs)
end
['Av. El sol 421, Cusco', 'Av. Calle Nueva 106, Cusco'].each do |bs|
  interbank.bank_subsidiaries.create(address: bs)
end
```

Ahora ejecutamos nuestro seed.

```ruby
rake db:seed
```

> `rake db:seeds` carga la data de `db/seeds.rb` en nuestra base de datos.

Ahora iniciamos el servidor

```ruby
rails s
```

## Mostrando las sucursales en el detalle del banco <a name="paso4"></a>

Cuando entremos al detalle de un banco nos debe mostrar todas las sucursales asociadas a este. Para esto tenemos que modificar en archivo `/app/views/banks/show.html.erb` y agregar lo que esta entre la linea 8 y 18:



```ruby
<p id="notice"><%= notice %></p>

<p>
  <strong>Name:</strong>
  <%= @bank %> # podemos borrar .name gracias al método to_s que definimos mas arriba
</p>

# Línea 8
<h2>Sucursales</h2>

<% if @bank.bank_subsidiaries.any? %>
	<ul>
		<% @bank.bank_subsidiaries.each do |subsidiary| %>
		<li><%= link_to subsidiary, subsidiary %></li> # no es necesario usar .address gracias al método to_s que definimos mas arriba
		<% end %>
	</ul>
<% else %>
	<p>no hay sucursales</p>
<% end %>
# Línea 18

<%= link_to 'Edit', edit_bank_path(@bank) %> |
<%= link_to 'Back', banks_path %>
```

## Modificando el formulario del modelo `bank` <a name="paso5"></a>

En el siguiente paso modificaremos el formulario del modelo `bank` para que podamos agregar sucursales cuando entramos a editar el banco. Para esto usaremos el **Helper** `fields_for`.

Modificamos el archivo `app/views/bank/_form.html.erb`

```ruby
<div class="field">
  <%= form.label :name %><br>
  <%= form.text_field :name %>
</div>

<h2>Sucursales</h2>

<%= form.fields_for :bank_subsidiaries do | subsidiary | %>
  <div class="bank_subsidiaries_fields">
    <div class="fields">
      <%= subsidiary.label :address, "Direccion" %><br>
      <%= subsidiary.text_field :address %>
    </div>
  </div>
<% end %>
```


Si entramos a editar el banco tendremos un campo para añadir una sucursal pero no está mostrando las sucursales existentes. Para lograr esto vamos a modificar nuestro modelo `bank` y añadiremos lo siguiente en el archivo `app/models/bank.rb`


```ruby
class Bank < ActiveRecord::Base
  has_many :bank_subsidiaries, dependent: :destroy

  accepts_nested_attributes_for :bank_subsidiaries

  validates :name, presence: true

  def to_s
    name
  end
end
```

Si refrescamos la página veremos que se mostrarán las sucursales asociadas al banco seleccionado 🏦.


## Editando una sucursal <a name="paso6"></a>

Si tratamos de editar alguna de las sucursales nos daremos cuenta que el cambio no se aplica. Revisemos la consola y veremos el siguiente mensaje:

> Unpermitted parameter: bank_subsidiaries_attributes

Lo que tenemos que hacer ahora es ir al controlador de `bank` y agregamos `bank_subsidiaries_attributes` a los strong parameters. *Esta es una medida de seguridad de Rails 4.*

Modificamos el `app/controllers/banks_controller.rb`

```ruby
private
   # Use callbacks to share common setup or constraints between actions.
   def set_bank
     @bank = Bank.find(params[:id])
   end

   # Never trust parameters from the scary internet, only allow the white list through.
   def bank_params
     params.require(:bank).permit(:name, bank_subsidiaries_attributes: [:id, :address])
   end
end
```

Ahora si se aplicaran los cambios cuando editamos una sucursal ✨


## Agregar una nueva sucursal <a name="paso7"></a>

Ya podemos editar un banco y listar las sucursales asociadas. Sin embargo, todavía nos podemos añadir una nueva sucursal. Para esto modificaremos el método edit en ` /app/controllers/banks_controller.rb`


```ruby
 # GET /banks/1/edit
 def edit
   @bank.bank_subsidiaries.build
 end
```

Ahora podemos agregar una nueva sucursal. Sin embargo, si hacemos una prueba tendremos un error. Esto se debe a que en nuestro modelo `bank_subsidiary` no permite tener el campo `address` vacío (validates :address, presence: true). Esta validación no la podemos eliminar por lo que tendremos que hacer lo siguiente:

Modificamos `/app/models/bank.rb`

```ruby
class Bank < ActiveRecord::Base
  has_many :bank_subsidiaries, dependent: :destroy

  accepts_nested_attributes_for :bank_subsidiaries,
    reject_if: proc { |attr| attr['address'].blank? }

  validates :name, presence: true

  def to_s
    name
  end
end
```

Lo que hicimos fue, a nuestro `accept_nested_attributes_for`, agregar un `reject_if` que comprueba si el atributo anidado está en blanco. Si no esta no toma en cuenta el `accept_nested_attributes_for` y envía el formulario sin ellos.

Para tener la posibilidad de añadir una sucursal en el mismo formulario necesitamos un pequeño cambio en el método new de `/app/controllers/banks_controller.rb`


```ruby
# GET /banks/new
 def new
   @bank = Bank.new
   @bank.bank_subsidiaries.build
 end
```


## Borrar una sucursal en el formulario del banco <a name="paso8"></a>

Ahora somos capaces de editar y crear sucursales en el formulario del banco. Pero aún no podemos eliminar en este formulario. Para poder hacer esto necesitaremos agregar `allow_destroy: true` a nuestro `accepts_nested_attributes_for:`


```ruby
class Bank < ActiveRecord::Base
  has_many :bank_subsidiaries, dependent: :destroy

  accepts_nested_attributes_for :bank_subsidiaries,
    reject_if: proc { |attr| attr['address'].blank? },
    allow_destroy: true

  validates :name, presence: true

  def to_s
    name
  end
end
```

También tenemos que modificar nuestro formulario para añadir la opción de borrar. Para esto agregaremos un campo `check_box` y lo pasamos como atributo  `:_destroy` (este se tiene que llamar así).


```ruby
<%= f.fields_for :bank_subsidiaries do | subsidiary | %>
    <div class="bank_subsidiaries_fields">
      <div class="fields">
        <%= subsidiary.label :address, "Direccion" %><br>
        <%= subsidiary.text_field :address %>
        <%= subsidiary.check_box :_destroy %>
        <%= subsidiary.label :_destroy, "Borrar" %>
      </div>
    </div>
<% end %>
```

Y obviamente tenemos que agregar este atributo en los strong parameter del controlador:


```ruby
# Never trust parameters from the scary internet, only allow the white list through.
   def bank_params
     params.require(:bank).permit(:name, bank_subsidiaries_attributes: [:id, :address, :_destroy])
   end
```

Ahora si podemos **agregar, editar y eliminar sucursales** desde el mismo formulario del **banco**!! 🎉


## Más información <a name="more-info"></a>

* Mas sobre **Nested Forms** en este [link](https://guides.rubyonrails.org/form_helpers.html#building-complex-forms)

* Si quieres aprender mas sobre Nested Attributes puede revisar el siguiente [link](https://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html)


## Siguientes pasos <a name="next-steps"></a>

### Configurar el sitio agregando Bootstrap

* Agregar CDN
* Agregar un Menú con Bootstrap y enlazar la navegación.
