# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
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
