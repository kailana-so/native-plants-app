require 'pg'

# refactored opening, passing sql and closing db connection
def run_sql(sql, arr = [])
    db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'native_plants'})
    results = db.exec_params(sql, arr)
    db.close
    return results
end
  