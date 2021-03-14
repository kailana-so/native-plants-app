require 'bcrypt'
require 'pg'

password_digest = BCrypt::Password.create(password)

sql = "INSERT INTO users (username, email, password_digest) VALUES ('#{username}', '#{email}','#{password_digest}');"

db = PG.connect(dbname: 'native_plants')

#  this runs the above
db.exec(sql)
db.close